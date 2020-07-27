%--------------------------------------------------------------------------
% PMA_STRUCT_ExpandGraphs.m
% Generate all structured graphs from a single simple graph
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Output = PMA_STRUCT_ExpandGraphs(R,P,S,opts,Graph)

% expand S and P
S = repelem(S,R);
P = repelem(P,R);

% double the value of the loops since there are two ports connected
Graph.A = Graph.A + diag(diag(Graph.A));

% expand the structured components with the recursive function below
Output = Structured_Modify(Graph,P,S,Graph.L,opts);

end

% function that expands one structured component at a time
function Output = Structured_Modify(Input,P,S,L,opts)

% check if any structured components remain
if (sum(S) == 0)
    Output = Input;
    % if we are using the AIO method, perform isomorphism checking
    if strcmpi(opts.structured.isotree,'AIO')
        Output = PMA_STRUCT_RemovedColoredIsos(Output,opts);
    end
    return; % no more modifications needed
end

% find the location of the next structured component
iStruct = find(S,1,'first');

% number of ports for the current structured component
np = P(iStruct);

% expand the vectors
[L,S,P] = PMA_STRUCT_ExpandPorts(L,S,P);

% initialize intermediate graphs
Inter = [];

% go through each graph in Input
for l = 1:length(Input)

    % extract current Graph
    Graph = Input(l);

    % extract adjacency matrix
    A = Graph.A;

    % adjacency matrix with 0 diagonal
    Anodiag = A - diag(diag(A));

    % find external connections for current structured component
    Lo = find(Anodiag(iStruct,:));

    % vector of external connection indices handling multi-edges
    IExtCon = []; % initialize
    for k = 1:numel(Lo) % go through each connection
        IExtCon = [IExtCon; Lo(k)*ones(A(Lo(k),iStruct),1)];
    end

    % calculate the number of loops (internal connections)
    nl = Graph.A(iStruct,iStruct)/2;

    % generate all permutations (both loops and multi-edges)
    [PermLoops,StructPortInd,ExtPortInd] = PMA_STRUCT_GeneratePermutations(IExtCon,nl);

    % total number of permutations
    NPerms = size(StructPortInd,1);

    %------------------------------------------------------------------
    % task: modify graph - expand A
    %------------------------------------------------------------------
    % remove row/column in A for current structured component
    A(iStruct,:) = [];
    A(:,iStruct) = [];

    % insert rows for each port in the current structured component
    for k = 1:np
        I = iStruct + k - 1;
        A = [A(:,1:I-1), zeros(length(A),1), A(:,I:end)];
        A = [A(1:I-1,:); zeros(1,length(A)); A(I:end,:)];
    end

    % add default internal connections (complete graph between ports)
    U = ones(np)-eye(np); % complete graph without loops
    shift = iStruct-1; % shift amount
    [Icomplete,Jcomplete,~] = find(U);
    A = A + sparse(Icomplete+shift,Jcomplete+shift,1,length(A),length(A));

    % replicate A matrix for each permutation
    Acell = repmat({A},NPerms,1);

    %------------------------------------------------------------------
    % task: modify graph - internal connections
    %------------------------------------------------------------------
    % shift indices to be in the correct location in expanded A
    PermLoops = PermLoops + iStruct - 1;

    % add each loop
    for k = 1:NPerms
       for i = 1:size(PermLoops,2)/2
           I1 = PermLoops(k,2*i-1); % odd location in PermLoops
           I2 = PermLoops(k,2*i); % even location in PermLoops
           Acell{k}(I1,I2) = 1 + Acell{k}(I1,I2); % add connection
           Acell{k}(I2,I1) = Acell{k}(I1,I2); % symmetric
       end
    end

    %------------------------------------------------------------------
    % task: modify graph - external connections
    %------------------------------------------------------------------
    % shift indices to be in the correct location in expanded A
    StructPortInd = StructPortInd + iStruct - 1;

    % shift indices to be in the correct location in expanded A
    ExtPortInd = ExtPortInd + (ExtPortInd > iStruct)*(np - 1);

    % add each external connection
    for k = 1:NPerms
        for i = 1:size(StructPortInd,2)
           I1 = StructPortInd(k,i); % internal index
           I2 = ExtPortInd(k,i); % external index
           Acell{k}(I1,I2) = 1 + Acell{k}(I1,I2); % add connection
           Acell{k}(I2,I1) = Acell{k}(I1,I2); % symmetric
        end
    end

    % assign expanded labels
    Graph.L = L;
    Graph.Ln = base2dec(L,36)';

    % replicate graph structure
    Graph = repmat(Graph,1,NPerms);

    % assign new A matrices
    for k = 1:NPerms
        Graph(k).A = Acell{k};
    end

    % combine structures
    Inter = [Inter, Graph];

end

% if we are using the LOE method, perform isomorphism checking
if strcmpi(opts.structured.isotree,'LOE')
    Inter = PMA_STRUCT_RemovedColoredIsos(Inter,opts,iStruct,np);
end

% recursively call to continue expanding
Output = Structured_Modify(Inter,P,S,L,opts);

end