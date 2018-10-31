%--------------------------------------------------------------------------
% PMA_RemoveIsoColoredGraphsPython.m
% Given a set of colored graphs, determine the set of nonisomorphic colored
% graphs
% Python implementation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function UniqueGraphs = PMA_RemoveIsoColoredGraphsPython(Graphs,opts)

% extract
displevel = opts.displevel;

% output to the command window
if (displevel > 1) % verbose
    disp('Now checking graphs for uniqueness...')
end

% import isomorphism checking function
py.importlib.import_module('detectiso_func4'); % import module 

% number of graphs to check
n = length(Graphs);

% determine if parallel computing should be used
if n < 2000 % parallel computing would be slower
    parallelTemp = 0; % no parallel computing
    Nbin = 1; % number of bins
else
    parallelTemp = opts.parallel; 
%     Nbin = opts.Nbin; % need to add
    Nbin = 1; % number of bins
end

% initialize
IndList = 1:n; % index list
nNonIso = 0; % number of nonisomorphic graphs found
% typearray = zeros(n,1);

% compute various metrics once
[pylist,colors,diags,edges,triangles,nnode,sumadj,degrees] = deal(cell(n,1));
if parallelTemp > 0
    parfor (i = 1:n, parallelTemp)
        [~,Isort] = sort(Graphs(i).Ln); % sort for unique representation
        At = Graphs(i).A;
        At = At(Isort,:);
        At = At(:,Isort);
        nnode{i} = uint64(size(At,1));
        colors{i} = uint64(Graphs(i).Ln(Isort));
        sumadj{i} = sum(At(:));
        pylist{i} = int8(At(:)');
        diags{i} = sort(diag(At));
        edges{i} = sort(nonzeros(At(:)));
        triangles{i} = sort(diag(At^3));
        degrees{i} = sort(sum(At,1));
    end
else
    for i = 1:n
        [~,Isort] = sort(Graphs(i).Ln); % sort for unique representation
        At = Graphs(i).A;        
        At = At(Isort,:);
        At = At(:,Isort);
        nnode{i} = uint64(size(At,1));
        colors{i} = uint64(Graphs(i).Ln(Isort));
        sumadj{i} = sum(At(:));
        pylist{i} = int8(At(:)');
        diags{i} = sort(diag(At));
        edges{i} = sort(nonzeros(At(:)));
        triangles{i} = sort(diag((At-diag(diag(At)))^3));
        degrees{i} = sort(sum(At,1));
        
        Ct = PMA_ConnCompBins(At);
        
    end
end

% first graph is always unique so store it
bin{1} = IndList(1);
nNonIso = nNonIso + 1;

% initialize dispstat
if (displevel > 0) % minimal
    dispstat('','init') % does not print anything
    Ndispstat = floor((n-1)/100);
end

% check remaining graphs for uniqueness
for i = 2:n
    % get candidate graph information
    C_nnode = nnode{i};
    C_colors = colors{i};
    C_pyadj = pylist{i};
    C_sumadj = sumadj{i};
    C_diag = diags{i};
    C_edge = edges{i};
    C_triangles = triangles{i};
    C_degrees = degrees{i};

    % initialize
    results = ones(min(Nbin,nNonIso),1);

% 	parfor (c = 1:min(Nbin,nNonIso), parallelTemp) % this works now but is slow
	for c = 1:min(Nbin,nNonIso)
        
        j = length(bin{c}); % number of graphs in the current bin
        IsoFlag = false; % initialize isoFlag
        
        % go through each graph in the bin
        while (j > 0) && (IsoFlag == 0)            
          nnode2 = nnode{bin{c}(j)};
          % compare # of nodes
          if isequal(C_nnode,nnode2) 
            color2 = colors{bin{c}(j)};
            % compare color distributions
            if isequal(C_colors,color2) 
              % compare # of edges
              if isequal(C_sumadj,sumadj{bin{c}(j)}) 
                % compare edges
                if isequal(C_edge,edges{bin{c}(j)}) 
                  % compare loops
                  if isequal(C_diag,diags{bin{c}(j)}) 
                    % compare degree distributions
                    if isequal(C_degrees,degrees{bin{c}(j)}) 
                      % compare triangle distributions
                      if isequal(C_triangles,triangles{bin{c}(j)}) 
                        pyadj2 = pylist{bin{c}(j)};
                        IsoFlag = py.detectiso_func4.detectiso(C_pyadj,pyadj2,...
                          C_colors,color2,C_nnode,nnode2);
                      end
                    end
                  end
                end
              end
            end
          end
          % if IsoFlag
          %     typearray(i) = 1;

          % end

          % go to the next graph
          j = j - 1;
        end
        results(c) = IsoFlag;
	end
    
    % check if the candidate graph is unique
    if ~any(results) % unique
        % get bin index
        J = mod(nNonIso, Nbin) + 1;
        
        % check if this is the first graph in the bin
        if (nNonIso + 1 <= Nbin) % first graph
            bin{J}(1) = IndList(i);
        else % not the first graph
            bin{J}(end+1) = IndList(i);
        end
        
        % increment since a unique graph was found
        nNonIso = nNonIso + 1;
    end
    
    % output some stats to the command window    
    if (displevel > 1) % verbose
        if mod(i,Ndispstat) == 0
            dispstat(['Percentage complete: ',int2str(ceil(i/n*100)),' %'])
        end
    end
end

% combine all the bins
UniqueGraphs = cell(1,Nbin); % initialize
for c = 1:Nbin % go through each bin
    if ~isempty(bin{c}) % only if the bin is not empty
        UniqueGraphs{c} = Graphs(bin{c});
    end
end
UniqueGraphs = horzcat(UniqueGraphs{:});

% output some stats to the command window
if (displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Found ',num2str(length(UniqueGraphs)),' unique graphs in ',...
        num2str(ttime),' s'])
end

end
% original python importing code
% does not seem to be needed with the inclusion of PMA_ChangeFolder.m
% origdir = pwd; % original directory
% pydir = mfoldername('PMA_RemoveIsoColoredGraphs','python'); % python directory
% cd(pydir) % change directory
% return to the original directory
% cd(origdir);