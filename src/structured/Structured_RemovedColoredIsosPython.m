%--------------------------------------------------------------------------
% Structured_RemovedColoredIsosPython.m
% Given a set of colored graphs, determine the set of nonisomorphic colored
% graphs, Python and structured graph-specific implementation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli, Undergraduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function UniqueGraphs = Structured_RemovedColoredIsosPython(Graphs,opts)

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

% obtain the number of ports and whether the graphs are structured
[P,S,~]= Structured_ShrinkLabel(Graphs(1));

% get structured labels of the graph
Labels = Graphs.L;

% get all indices of the structured components
structuredIdx = find(S==1);

% get the a sequences representing the number of labels
Idxes = 1:length(Labels);

% initialize
nNonIso = 0; % number of nonisomorphic graphs found
% typearray = zeros(n,1);
% v = zeros(1,n); % keeps track of isomorphism status of the graphs

% compute various metrics once
pylist = cell(n,1);
colors = pylist;
nnode = zeros(n,1,'uint64');
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
end

% compute the Internal Index and External Maps for each graph once
SubGraphs = cell(1,n);
for i = 1:n
    graph = Graphs(i);
    % for every structured component
    for j = 1:length(structuredIdx)
        % current structure component index
        iStruct =  structuredIdx(j);
        
        % get the number of ports for the structured Component
        np = P(iStruct);
        
        % get the index of current structured component in the expanded graph
        structPos = iStruct+sum(P(1:iStruct-1).*S(1:iStruct-1))-sum(S(1:iStruct-1));
        for k = 0:np-1
            idx = structPos + k;
            connection = find(graph.A(structPos,:) > 0);
        end
    end
end

% attach to the Graphs structure
for i = 1:n
    Graphs(i).nnode = nnode(i);
    Graphs(i).colors = colors{i};
    Graphs(i).sumadj = sumadj(i);
    Graphs(i).pylist = pylist{i};
    Graphs(i).IntConnections = IntCellOfIndex{i};
    Graphs(i).ExtConnections = ExtCellOfMaps{i};
end

% first graph is always unique so store it
bin(1).Structured_Graphs(1) = Graphs(1);
nNonIso = nNonIso + 1;

% check remaining graphs for uniqueness
for i = 2:n
    nnode1 = nnode(i);
    color1 = colors{i};
    pyadj1 = pylist{i};
    IntIndexes1 = IntCellOfIndex{i};
    ExtMaps1 = ExtCellOfMaps{i};
	for c = 1:min(Nbin,nNonIso) 
        j = length(bin(c).Structured_Graphs);
        % get the internal connection of the bin first
        IntIndexes2 = bin(c).Structured_Graphs(j).IntConnections;
        IsoFlag = 0;   
        while (j > 0) && (IsoFlag == 0)
            % check if the Internal connection is the same
            if checkInt(IntIndexes1,IntIndexes2)
                ExtMaps2 = bin(c).Structured_Graphs(j).ExtConnections;
                % check if the external connection is the same
                if checkExt(ExtMaps1,ExtMaps2)
                    pyadj2 = bin(c).Structured_Graphs(j).pylist;
                    color2 = bin(c).Structured_Graphs(j).colors;
                    nnode2 = bin(c).Structured_Graphs(j).nnode;
                    %Run the full check
                    IsoFlag = py.detectiso_func4.detectiso(pyadj1,pyadj2,...
                                color1,color2,nnode1,nnode2);
                end
            end
            j = j - 1;
        end
        results(c) = IsoFlag;
	end
    
    if any(results) % not unique
        % v(i) = 0;
    else % unique
        % v(i) = 1;

        % get bin index
        J = mod(nNonIso, Nbin) + 1;
        
        % check if this is the first graph in the bin
        if (nNonIso + 1 <= Nbin) % first graph
            bin(J).Structured_Graphs(1) = Graphs(i);
        else % not the first graph
            bin(J).Structured_Graphs(end+1) = Graphs(i);
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
        UniqueGraphs = [UniqueGraphs, bin(c).Structured_Graphs];
    end
end

% remove some fields
UniqueGraphs = rmfield(UniqueGraphs,'colors');
UniqueGraphs = rmfield(UniqueGraphs,'pylist');
UniqueGraphs = rmfield(UniqueGraphs,'nnode');
UniqueGraphs = rmfield(UniqueGraphs,'sumadj');
UniqueGraphs = rmfield(UniqueGraphs,'IntConnections');
UniqueGraphs = rmfield(UniqueGraphs,'ExtConnections');

end
% check if two graphs are definitely unique from the internal indexes
function IsoFlag = checkInt(IntIndexes1,IntIndexes2)
    % if the lengths are not the same, they are unique
    if length(IntIndexes1) ~= length(IntIndexes2)
        IsoFlag = 0;
        return;
    end

    IsoFlag = 1;
    % loop through every pair of indexes
    for a = 1:length(IntIndexes1)
        % if both are empty, treat it as not unique
        if isempty(IntIndexes1{a}) && isempty(IntIndexes2{a})
            continue;
        end

        % if we find one pair of indices that are not the same, we conclude
        % that the two graphs are unique
        if ~isequal(IntIndexes1{a},IntIndexes2{a})
           IsoFlag = 0;
           return;
        end
    end
end
% check if two graphs are definitely unique from the External Check Map
function IsoFlag = checkExt(ExtMaps1,ExtMaps2)
    % if the lengths are not the same, they are unique
    if length(ExtMaps1) ~= length(ExtMaps2)
       IsoFlag = 0;
       return;
    end
    IsoFlag = 1;
    
    % loop through every pair of Maps
    IMap = [];
    JMap = [];
    for b = 1:length(ExtMaps1)
        for c = 1:length(ExtMaps2)
             % we check if there is a graph in the other output that is
             % isomorphic to it. Then we record the number in both Outputs
             map1 = ExtMaps1{b};
             map2 = ExtMaps2{c};
             
             if length(keys(map1))==length(keys(map2)) && all(strcmp(keys(map1),keys(map2))) 
                Keys = keys(map1);
                for d = 1:length(map1)
                    key = Keys{d};
                    map1(key) = sort(map1(key));
                    map2(key) = sort(map2(key));
                end
                if ~all(strcmp(values(map1),values(map2)))
                    IsoFlag = 0;
                    return;
                else
                    IMap = [IMap b];
                    JMap = [JMap c];
                end
             end
            % if we search through the entire OrigOutput and did not find 
            % one, we conclude that this sort method does not provide the same output
        end
        % if keys are not the same, we conclude that the two graphs are not
        % isomorphic
        
        % for every key-value pair, sort the value for comparison
        
        % after sorting if the values are still not the same for the map,
        % then we conclude the two graphs are unique
    end
    if sum(ismember(IMap,JMap)) ~= length(ExtMaps1)
        IsoFlag = 0;
    end
end