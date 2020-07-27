%--------------------------------------------------------------------------
% PMA_STRUCT_SimpleCheckConnections.m
% Create the required data for the simple checks
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [IntData,ExtData] = PMA_STRUCT_SimpleCheckConnections(Graphs,iStruct,np)

% get the number of graphs
n = length(Graphs);

% start/end of the current structured component's ports in adjacency matrix
strStart = iStruct;
strEnd = iStruct+np-1;

% ExtData is an array captures the external connections
% since all the graphs expand the same structured component at the
% current level, every cell in ExtData represents the connection orders
% of the same structured component of each graph in Graphs
ExtData = cell(1,n);

% IntData captures the edges of internal (self loop) connections
IntData = cell(1,n);

% get the data for the internal and external connections
for idx = 1:n

    % get the current graph
    graph = Graphs(idx);

    %
    [uniqueLabels,uniqueIndex] = Structured_CreateConnectedLabels(graph,iStruct,np);

    % create the array for connected labels (not guaranteed to be
    % unique)
    Arr = cell(1,length(uniqueLabels));

    % create indices for internal connections and store in IntData
    [intIdx,~] = find(graph.A(strStart:strEnd,strStart:strEnd)>1);
    IntData{idx}= intIdx';

    % for every uniqueLabel
    for j = 1:length(uniqueLabels)

       % get the index representing the connected component
       Indices = uniqueIndex{j};

       % find the ports of the structured component it connects to
       extcheckA = graph.A(Indices,strStart:strEnd);
       [~,portNums] = find(extcheckA);

       % sort the portNumbers and store in Arr
       Arr{j} = sort(portNums');

    end

    % finally covert Arr to an array for easy comparison
    ExtData{idx} = cell2mat(Arr);

end

end

% uniqueLabels -> labels connected to structured component
% uniqueIndex -> indices representing the labels in uniqueLabels
function [uniqueLabels,uniqueIndex] = Structured_CreateConnectedLabels(graph,iStruct,np)

% start/end of ports of structured component in the adjacency matrix
Start = iStruct;
End = iStruct+np-1;

% 1 to number of labels
Idxes = 1:length(graph.L);

% get the part of adjacency matrix to check for external connections
externalIdx = [Idxes(1:Start-1) Idxes(End+1:end)];
extcheckA = graph.A(externalIdx,Start:End);

% create labels connected to the structured component
% and indices of the labels (may not be unique)
connectedLabels = cell(1,np);
connectedIndex = zeros(1,np);
for k = 1:np

    % get part of adjacency matrix for construction of the map
    extColumn = extcheckA(:,k);

    % fill the connectedLabels and connectedIndex
    if ~isempty(find(extColumn,1))
        idx = find(extColumn>0);
        strIdx = idx+(idx>=Start)*np;
        connectedLabels{k} = graph.L{strIdx};
        connectedIndex(k) = strIdx;
    end
end

% unique version of connectedLabels to ports of structured component
uniqueLabels = unique(connectedLabels);

% set up for uniqueIndex
uniqueIndex = cell(1,length(uniqueLabels));

% get every index in adjacency matrix representing the connected labels
% to ports of structured component
for l = 1:length(uniqueLabels)
   IndexC = strfind(connectedLabels, uniqueLabels{l});
   Index = find(not(cellfun('isempty', IndexC)));
   uniqueIndex{l} = connectedIndex(Index);
end

end