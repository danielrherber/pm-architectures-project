%--------------------------------------------------------------------------
% PMA_RemoveIsoLabeledGraphs.m
% Given a set of labeled graphs, determine the set of nonisomorphic labeled
% graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [UniqueGraphs,varargout] = PMA_RemoveIsoLabeledGraphs(varargin)

% parse inputs
switch length(varargin)
    %----------------------------------------------------------------------
    case 2 % filtering from a structure of graphs
        inputtype = 1;
        [Graphs,opts] = deal(varargin{:});

        % extract
        displevel = opts.displevel;
        isomethod = opts.isomethod;
    %----------------------------------------------------------------------
    case 6 % called within the BFS graph generation algorithm
        inputtype = 2;
        [Graphs,Tsort,Vsort,Ln,displevel,isomethod] = deal(varargin{:});

        Nc = length(Ln); % number of components (constant in BFS algorithm)
        [I2,J2] = ind2sub(Nc,Tsort); % subscripts from linear index
        Vcc = ones(1,size(I2,2)); % one for each edge
    %----------------------------------------------------------------------
    otherwise
        error('Unknown inputs to PMA_RemoveIsoLabeledGraphs')
end

% parse outputs
if length(nargout) == 1
    isoGraphIdxFlag = true;
else
    isoGraphIdxFlag = false;
end

% if no graphs
if isempty(Graphs)
    UniqueGraphs = []; % report empty if no graphs present
    if isoGraphIdxFlag
      varargout{1} = []; % report empty if no graphs present
    end
    return
end

% if only one graph
if length(Graphs) == 1
    UniqueGraphs = Graphs;
    if isoGraphIdxFlag
       varargout{1} = 1;
    end
    return
end

% parse isomorphism method specification
switch lower(isomethod) % case insensitive
    %----------------------------------------------------------------------
    case {0,'none'} % don't check for labeled graph isomorphisms
        if (displevel > 0) % minimal
            disp('-> no isomorphism checking using the ''none'' option')
        end
        UniqueGraphs = Graphs;
        return; % exit function
    %----------------------------------------------------------------------
    case {1,'matlab'} % matlab implementation
        method = 1;
    %----------------------------------------------------------------------
    case {2,'py-igraph'} % python igraph implementation
        method = 2;
        py.importlib.import_module('detectiso_igraph'); % import module
    %----------------------------------------------------------------------
    case {3,'py-networkx'} % python networkx implementation
        method = 3;
        py.importlib.import_module('detectiso_networkx'); % import module
    %----------------------------------------------------------------------
    otherwise
        error('Unknown isomorphism checking option selected')
end

% output to the command window
if (displevel > 1) % verbose
    disp('Now checking graphs for uniqueness...')
end

% number of graphs to check
n = length(Graphs);

% number of bins
Nbin = 1; % number of bins
% Nbin = opts.Nbin; % number of bins, need to expose

% initialize
[nvertices,nedges] = deal(zeros(n,1,'uint64'));
ndeterminant = zeros(n,1,'int64');
multiflag = false(n,1);
[dlabels,dloops,dedges,ddegrees,dconnected,dspectrum,dlabelspectrum,...
    dports,adjacency] = deal(cell(n,1));
if method == 1 % matlab
   G0 = graph(); % empty graph
   G = cell(n,1);
end
if method == 2 % python
    pylist = cell(n,1);
end
if isoGraphIdxFlag
   isoGraphIdx = zeros(n,1);
end

% compute various metrics once
for i = 1:n
    % obtain graph
    switch inputtype
        %------------------------------------------------------------------
        case 1 % filtering from a structure of graphs
            % extract
            Ln = Graphs(i).Ln;
            At = Graphs(i).A;

            % sort for unique representation
            [~,Isort] = sort(Ln);
            Ln = Ln(Isort);
            At = At(Isort,:);
            At = At(:,Isort);
        %------------------------------------------------------------------
        case 2 % called within the BFS graph generation algorithm
            % obtain adjacency matrix
            At = full(sparse(I2(i,:),J2(i,:),Vcc,Nc,Nc));
            At = At + At'; % symmetric
            At = At - diag(diag(At))/2;
    end

    % store adjacency matrix
    adjacency{i} = At;

    % compute metrics
    multiflag(i) = any(At(:)>1);
    nvertices(i) = uint16(size(At,1));
    nedges(i) = uint16(sum(At(:)));
    ndeterminant(i) = int64(det(At));
    dlabels{i} = uint64(Ln);
    edges = nonzeros(At(:))';
    dedges{i} = uint8(edges);
    multiflag(i) = any(edges>1);
    % dtriangles{i} = uint16(diag((At-diag(diag(At)))^3))';
    ddegrees{i} = uint8(sum(At,1));
    dloops{i} = uint16(diag(At))';
    spectrum = svd(At)'; % eig(At)'
    dspectrum{i} = single(spectrum/max(spectrum));

    [ncc,cc] = PMA_ConnCompBins(At); % determine connected components
    bins = cell(1,ncc); % initialize
    for j = 1:ncc % go through each connected component
        bins{j} = [Ln(cc==j),-1]; % create bin and add spacer
    end
    [~,I] = sortrows(PMA_PadCatRowVectors(bins{:})); % sort bins
    bins = bins(I); % sort bins
    dconnected{i} = horzcat(bins{:}); % catenate sorted cc bins

    if inputtype == 2
        dports{i} = uint16(Vsort(i,:));
    end

    % method-specific operations
    if method == 2 % python igraph
        pylist{i} = int8(At(:)');
    elseif method == 3 % python networkx
        pylist{i} = int8(At(:)');
    elseif method == 1
        % matlab graph object
        Gt = G0;
        [I,J,V] = find(At);
        Gt = addedge(Gt,I,J,V);
        Gt.Nodes.Color = (Ln)';  % FIX: remove Ln for zero rows
        G{i} = Gt;
    end
end

switch method
    case {2,3} % python
        pydlabels = dlabels; % store unaltered labels for python
end

% convert cell arrays into matrices
dedges = PMA_PadCatRowVectors(dedges{:});
dlabels = PMA_PadCatRowVectors(dlabels{:}); % already sorted
% dtriangles = PMA_PadCatRowVectors(dtriangles{:});
ddegrees = PMA_PadCatRowVectors(ddegrees{:});
dloops = PMA_PadCatRowVectors(dloops{:});
dconnected = PMA_PadCatRowVectors(dconnected{:});
dspectrum = PMA_PadCatRowVectors(dspectrum{:}); % already sorted
if inputtype == 2
    dports = PMA_PadCatRowVectors(dports{:});
end

% compute label-shifted spectrum
[~,~,IC] = unique(dlabels); % obtain unique indices
dlabels2 = reshape(IC,size(dlabels));
% check if zeros are present
if ~all(dlabels,'all')
    dlabels2 = dlabels2 - 1; % shift by 1 to retain original zeros
end
% go through each graph
for i = 1:n
    dlabel = dlabels2(i,:); % extract
    dlabel(dlabel==0) = []; % remove zero indices
    labelspectrum = svd(adjacency{i}+double(diag(dlabel)))'; % eig(At)'
    dlabelspectrum{i} = single(labelspectrum/max(labelspectrum));
end
dlabelspectrum = PMA_PadCatRowVectors(dlabelspectrum{:}); % already sorted

% sort various metrics
dedges = sort(dedges,2);
switch inputtype
    %----------------------------------------------------------------------
    case 1 % filtering from a structure of graphs
        % dtriangles = sort(dtriangles,2);
        ddegrees = sort(ddegrees,2);
        dloops = sort(dloops,2);
    %----------------------------------------------------------------------
    case 2 % called within the BFS graph generation algorithm
        % dtriangles = PMA_BinBasedSorting(dtriangles,Ln);
        ddegrees = PMA_BinBasedSorting(ddegrees,Ln);
        dloops = PMA_BinBasedSorting(dloops,Ln);
        dports = PMA_BinBasedSorting(dports,Ln);
end

% map graph invariants to bin indices
tol = 1e-6; % absolute tolerance for spectrum
[~,~,blabelspectrum] = uniquetol(dlabelspectrum,tol,'ByRows',true,'DataScale',1);
[~,~,bspectrum] = uniquetol(dspectrum,tol,'ByRows',true,'DataScale',1);
[~,~,blabels] = unique(dlabels,'rows');
[~,~,bdegrees] = unique(ddegrees,'rows');
[~,~,bconnected] = unique(dconnected,'rows');
[~,~,bedges] = unique(dedges,'rows');
[~,~,bloops] = unique(dloops,'rows');
[~,~,bnedges] = unique(nedges);
[~,~,bnvertices] = unique(nvertices);
[~,~,bndeterminant] = unique(ndeterminant);

% sort graphs by label-shifted spectrum
% Isort = 1:length(Graphs); % original method
[~,Isort] = sortrows(dlabelspectrum);
Isort = Isort(:)';

% initialize number of nonisomorphic graphs found
nNonIso = 0;

% first graph is always unique so store it
bin{1} = Isort(1);
nNonIso = nNonIso + 1;

% number of graphs per percentage point
Ndispnum = floor((n-1)/100);

% check remaining graphs for uniqueness
for i = Isort(2:end)
    % get candidate graph information
    C_nv = nvertices(i); % number of vertices
    switch method
        case 1 % matlab
            C_G = G{i}; % matlab graph object
        case {2,3} % python
            C_pyadj = pylist{i}; % adjacency matrix list
            C_pydlabels = pydlabels{i}; % labels
    end

    % initialize
    results = true(min(Nbin,nNonIso),1);

% 	parfor (c = 1:min(Nbin,nNonIso), parallelTemp) % this works now but is slow
	for c = 1:min(Nbin,nNonIso)
        % extract bin indices
        Ibin = bin{c};

        % compare label-shifted spectrum
        Ikeep = blabelspectrum(Ibin)==blabelspectrum(i);
        Ibin = Ibin(Ikeep);

        % compare spectrum
        Ikeep = bspectrum(Ibin)==bspectrum(i);
        Ibin = Ibin(Ikeep);

        % compare label distributions
        Ikeep = blabels(Ibin)==blabels(i);
        Ibin = Ibin(Ikeep);

        % compare connected component distributions
        Ikeep = bconnected(Ibin)==bconnected(i);
        Ibin = Ibin(Ikeep);

        % compare degree distributions
        Ikeep = bdegrees(Ibin)==bdegrees(i);
        Ibin = Ibin(Ikeep);

        % compare edge distributions
        Ikeep = bedges(Ibin)==bedges(i);
        Ibin = Ibin(Ikeep);

        % compare loop distributions
        Ikeep = bloops(Ibin)==bloops(i);
        Ibin = Ibin(Ikeep);

        % compare number of edges
        Ikeep = bnedges(Ibin)==bnedges(i);
        Ibin = Ibin(Ikeep);

        % compare number of vertices
        Ikeep = bnvertices(Ibin)==bnvertices(i);
        Ibin = Ibin(Ikeep);

        % compare determinants
        Ikeep = bndeterminant(Ibin)==bndeterminant(i);
        Ibin = Ibin(Ikeep);

        % compare remaining port distributions
        if inputtype == 2
            Ikeep = all(dports(Ibin,:)==dports(i,:),2);
            Ibin = Ibin(Ikeep);
        end

        % compare triangle distributions
        % Ikeep = all(dtriangles(Ibin,:)==dtriangles(i,:),2);
        % Ibin = Ibin(Ikeep);

        % check no graphs to compare against
        if isempty(Ibin)
            results(c) = false;
            continue
        end

        % initialize
        IsoFlag = false;

        % check what isomorphism checking type is needed
        if any(multiflag([i,Ibin]))
            isotype = 3; % both label and edge weights needed
        else
            isotype = 1; % label weights needed
        end

        % method-specific isomorphism checking
        if method == 2 % python igraph
            for j = Ibin % go through each graph in the bin
                IsoFlag = py.detectiso_igraph.detectiso(C_pyadj,pylist{j},...
                    C_pydlabels,pydlabels{j},C_nv,nvertices(j),isotype);
                if IsoFlag
                    % A1 = double(reshape(C_pyadj,[C_nv C_nv]));
                    % A2 = double(reshape(pylist{j},[nvertices(j) nvertices(j)]));
                    % G1 = graph(A1); G2 = graph(A2);
                    % figure; hold on
                    % plot(G1,'NodeLabel',C_pydlabels);
                    % ha = gca; ha.Children.YData = ha.Children.YData + 3;
                    % plot(G2,'NodeLabel',pydlabels{j});
                    isoGraphIdx(i) = j;
                    break
                end
            end
        elseif method == 3 % python networkx
            for j = Ibin % go through each graph in the bin
                IsoFlag = py.detectiso_networkx.detectiso(C_pyadj,pylist{j},...
                    C_pydlabels,pydlabels{j},C_nv,nvertices(j));
                if IsoFlag
                    isoGraphIdx(i) = j;
                    break
                end
            end
        elseif method == 1 % matlab
            for j = Ibin % go through each graph in the bin
                if isotype == 1
                    IsoFlag = isisomorphic(C_G,G{j},'NodeVariables','Color');
                elseif isotype == 3
                    IsoFlag = isisomorphic(C_G,G{j},'NodeVariables','Color',...
                        'EdgeVariables','Weight');
                end
                if IsoFlag
                    isoGraphIdx(i) = j;
                    break
                end
            end
        end
        results(c) = IsoFlag;
	end

    % check if the candidate graph is unique
    if ~any(results) % unique
        % get bin index
        J = mod(nNonIso, Nbin) + 1;

        % check if this is the first graph in the bin
        if (nNonIso + 1 <= Nbin) % first graph
            bin{J}(1) = i;
        else % not the first graph
            bin{J}(end+1) = i;
        end

        % increment since a unique graph was found
        nNonIso = nNonIso + 1;
    end

    % output some stats to the command window
    if (displevel > 1) % verbose
        if (mod(i,Ndispnum) == 0) || (i == 2)
            % check if this is the first graph generated
            if i == 2
                fprintf('Percentage complete: '); % initial string
            else
                fprintf(repmat('\b', 1, 5)); % remove previous
            end
            % current percentage of graphs (fixed size)
            fprintf('%3d%%\n',int64(ceil(i/n*100)));
        end
    end
end

% combine all the bins
switch inputtype
    %----------------------------------------------------------------------
    case 1 % filtering from a structure of graphs
        UniqueGraphs = cell(1,Nbin); % initialize
        for c = 1:Nbin % go through each bin
            if ~isempty(bin{c}) % only if the bin is not empty
                UniqueGraphs{c} = Graphs(bin{c});
            end
        end
        UniqueGraphs = horzcat(UniqueGraphs{:});
    %----------------------------------------------------------------------
    case 2  % called within the BFS graph generation algorithm
        UniqueGraphs = Graphs(horzcat(bin{:}));
end

% (potentially) output isomorphic graph index array
if isoGraphIdxFlag
    % find unique graphs
    I2 = find(~isoGraphIdx);

    % assign index as itself
    isoGraphIdx(I2) = I2;

    % assign
    varargout{1} = isoGraphIdx;
end

% output some stats to the command window
if (displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Found ',num2str(length(UniqueGraphs)),' unique graphs in ',...
        num2str(ttime),' s'])
end


end

% try
% catch
%     % error statements
%     switch method
%         %----------------------------------------------------------------------
%         case 1 % matlab
%             error('PMA:PMA_RemoveIsoLabeledGraphs:matlabError',...
%                 ['An error occurred with the matlab option \n',...
%                 ' -> Check if MATLAB version is R2016b or newer']);
%         %----------------------------------------------------------------------
%         case 2 % python
%             error('PMA:PMA_RemoveIsoLabeledGraphs:pythonError',...
%                 ['An error occurred with the python option\n',...
%                 ' -> Check python installation with igraph']);
%     end
% end