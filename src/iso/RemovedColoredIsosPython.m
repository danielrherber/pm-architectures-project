%--------------------------------------------------------------------------
% RemovedColoredIsosPython.m
% Given a set of colored graphs, determine the set of nonisomorphic colored
% graphs, Python implementation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function UniqueGraphs = RemovedColoredIsosPython(Graphs,opts)

% output to the command window
if (opts.displevel > 1) % verbose
    disp('Now checking graphs for uniqueness...')
end

% import isomorphism checking function
origdir = pwd; % original directory
pydir = mfoldername('RemovedColoredIsos','python'); % python directory
cd(pydir) % change directory
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
nNonIso = 0; % number of nonisomorphic graphs found
% typearray = zeros(n,1);
% v = zeros(1,n); % keeps track of isomorphism status of the graphs

% compute various metrics once
pylist = cell(n,1);
colors = pylist;
diags = pylist;
edges = pylist;
nnode = zeros(n,1,'uint64');
sumadj = nnode;
parfor (i = 1:n, parallelTemp)
% for i = 1:n
    [~,Isort] = sort(Graphs(i).Ln); % sort for unique representation
    adj = Graphs(i).A;
    adj = adj(Isort,:);
    adj = adj(:,Isort);
    nnode(i) = uint64(size(adj,1));
    colors{i} = uint64(Graphs(i).Ln(Isort));
    sumadj(i) = sum(adj(:));
    pylist{i} = int8(adj(:)');
    diags{i} = sort(diag(adj));
    edges{i} = sort(nonzeros(adj(:)));
end

% attach to the Graphs structure
for i = 1:n
    Graphs(i).nnode = nnode(i);
    Graphs(i).colors = colors{i};
    Graphs(i).sumadj = sumadj(i);
	Graphs(i).pylist = pylist{i};
    Graphs(i).diags = diags{i};
    Graphs(i).edges = edges{i};
end

% first graph is always unique so store it
bin(1).Graphs(1) = Graphs(1);
nNonIso = nNonIso + 1;
% v(1) = 1;

% initialize dispstat
dispstat('','init') % does not print anything
Ndispstat = floor((n-1)/100);

% check remaining graphs for uniqueness
for i = 2:n
    % get candidate graph information
    nnode1 = nnode(i);
    color1 = colors{i};
    pyadj1 = pylist{i};
    sumadj1 = sumadj(i);
    diag1 = diags{i};
    edge1 = edges{i};

    % initialize
    results = ones(min(Nbin,nNonIso),1);

% 	parfor (c = 1:min(Nbin,nNonIso), parallelTemp) % this works now but is slow
	for c = 1:min(Nbin,nNonIso)
        
        j = length(bin(c).Graphs); % number of graphs in the current bin
        IsoFlag = 0; % initialize isoFlag
        
        while (j > 0) && (IsoFlag == 0)
            nnode2 = bin(c).Graphs(j).nnode;
            if isequal(nnode1,nnode2) % compare # of nodes
                color2 = bin(c).Graphs(j).colors;
                if isequal(color1,color2) % compare colors
                    if isequal(sumadj1,bin(c).Graphs(j).sumadj) % compare # of edges
                        if isequal(edge1,bin(c).Graphs(j).edges) % compare edges
                            if isequal(diag1,bin(c).Graphs(j).diags) % compare loops
                                pyadj2 = bin(c).Graphs(j).pylist;
                                IsoFlag = py.detectiso_func4.detectiso(pyadj1,pyadj2,...
                                        color1,color2,nnode1,nnode2);
                            end
                        end
                    end
                end
            end
            % if IsoFlag
            %     typearray(i) = bin(c).Graphs(j).N;
            % end
            j = j - 1;
        end
        results(c) = IsoFlag;
	end
    
    % check if the candidate graph is unique
    if any(results) % not unique
        % v(i) = 0;
    else % unique
        % v(i) = 1;

        % get bin index
        J = mod(nNonIso, Nbin) + 1;
        
        % check if this is the first graph in the bin
        if (nNonIso + 1 <= Nbin) % first graph
            bin(J).Graphs(1) = Graphs(i);
        else % not the first graph
            bin(J).Graphs(end+1) = Graphs(i);
        end
        
        % increment since a unique graph was found
        nNonIso = nNonIso + 1;
    end
    
    % output some stats to the command window    
    if (opts.displevel > 1) % verbose
        if mod(i,Ndispstat) == 0
            dispstat(['Percentage complete: ',int2str(round(i/n*100)),' %'])
        end
    end
    
end

% return to the original directory
cd(origdir);

% combine all the bins
UniqueGraphs = []; % initialize
for c = 1:Nbin % go through each bin
    if ~isempty(bin(c)) % only if the bin is not empty
        UniqueGraphs = [UniqueGraphs, bin(c).Graphs];
    end
end

% remove some fields
UniqueGraphs = rmfield(UniqueGraphs,'colors');
UniqueGraphs = rmfield(UniqueGraphs,'pylist');
UniqueGraphs = rmfield(UniqueGraphs,'nnode');
UniqueGraphs = rmfield(UniqueGraphs,'sumadj');
UniqueGraphs = rmfield(UniqueGraphs,'diags');
UniqueGraphs = rmfield(UniqueGraphs,'edges');

% output some stats to the command window
if (opts.displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Found ',num2str(length(UniqueGraphs)),' unique graphs in ', num2str(ttime),' s'])
end

end