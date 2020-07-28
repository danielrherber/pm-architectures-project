%--------------------------------------------------------------------------
% PMA_TreeGather.m
% Complete problem set up and use a particular method to generate graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [G,I,N] = PMA_TreeGather(Ln,P,R,NSC,opts,phi)

% set this number based on user value or predefined large value
Nmemory = opts.algorithms.Nmax;

% number of perfect matchings
Npm = 2*prod(1:2:(P'*R-1)); % factor of 2 needed for tree_v10

% maximum number of graphs to preallocate for or generate
% [in some cases, the code greatly slows if this number is succeeded]
if contains(opts.algorithm,'stochastic')
    Nmax = uint64(Nmemory);
else
    Nmax = uint64(min(Npm,Nmemory));
end

% vector when all ports are unconnected
Vf = uint8(NSC.Vfull);

% expand reduced potential adjacency matrix
A = PMA_ExpandPossibleAdj(NSC.directA,R,NSC);

% expand reduced potential multiedge adjacency matrix
Am = PMA_ExpandPossibleAdj(NSC.multiedgeA,R,NSC);

% check if B was provided
if NSC.flag.Bflag
    B = PMA_CreateBMatrix(NSC.lineTriple,R,NSC);
else
    B = uint8([]);
end

% initialize zero matrix where edge sets will be placed
G = zeros(Nmax,sum(Vf),'uint8');

% id is used to keep track of the number of graphs found
id = uint64(0);

% initialize empty edge set
E = uint8([]);

% vertex number + 1 in the connected ports graph of the first element of
% each component
cVf = uint8(cumsum(Vf)+1);

% vertex number in the connected component graph of the first components of
% a particular component type
iInitRep = uint8(cumsum(R)-R+1);

% update data type
phi = uint16(phi);

% extract
Bf = NSC.flag.Bflag;
Mf = NSC.flag.Mflag;
simple = NSC.simple;
M = NSC.M;
displevel = uint8(opts.displevel);
algorithm = opts.algorithm;
Pf = opts.algorithms.filterflag;
If = opts.algorithms.isoflag;
IN = opts.algorithms.isoNmax;
Im = opts.algorithms.isomethod;

% default option to use PMA_SortAsPerfectMatching
% [change in the algorithm structure below if necessary]
sortFlag = 1;

% global variable used to save the tree structure (optional addition)
if contains(algorithm,'analysis')
    global node nodelist labellist feasiblelist %#ok
    node = 1; % first node
    nodelist = []; % list of nodes
    labellist = []; % list of labels
    feasiblelist = []; % list of node feasibility
    prenode = 0; % root node
end

% use the specified algorithm
switch algorithm
    %----------------------------------------------------------------------
    % tree
    %----------------------------------------------------------------------
    case 'tree_v1'
        [G,~] = PMA_EnumerationAlg_v1(Vf,E,G,id,cVf,A,displevel);
    case 'tree_v8'
        [G,~] = PMA_EnumerationAlg_v8(Vf,E,G,id,cVf,Vf,iInitRep,...
            simple,A,Bf,B,Mf,M,displevel);
    case 'tree_v10'
        G = PMA_EnumerationAlg_v10(cVf,Vf,iInitRep,phi,simple,...
            A,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    case 'tree_v11DFS'
        [G,~] = PMA_EnumerationAlg_v11DFS(Vf,E,G,id,cVf,Vf,iInitRep,...
            simple,A,Bf,B,Mf,M,displevel);
    case 'tree_v11BFS'
        G = PMA_EnumerationAlg_v11BFS(cVf,Vf,iInitRep,phi,simple,...
            A,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    case 'tree_v12DFS'
        [G,~] = PMA_EnumerationAlg_v12DFS(Vf,E,G,id,cVf,Vf,iInitRep,...
            Am,Bf,B,Mf,M,displevel);
    case 'tree_v12BFS'
        G = PMA_EnumerationAlg_v12BFS(cVf,Vf,iInitRep,phi,...
            Am,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    %----------------------------------------------------------------------
    % mex
    %----------------------------------------------------------------------
    case 'tree_v1_mex'
        [G,~] = PMA_EnumerationAlg_v1_mex(Vf,E,G,id,cVf,A,displevel);
    case 'tree_v8_mex'
        [G,~] = PMA_EnumerationAlg_v8_mex(Vf,E,G,id,cVf,Vf,iInitRep,...
            simple,A,Bf,B,Mf,M,displevel);
    case 'tree_v10_mex'
        G = PMA_EnumerationAlg_v10_mex(cVf,Vf,iInitRep,phi,simple,...
            A,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    case 'tree_v11DFS_mex'
        [G,~] = PMA_EnumerationAlg_v11DFS_mex(Vf,E,G,id,cVf,Vf,iInitRep,...
            simple,A,Bf,B,Mf,M,displevel);
    case 'tree_v11BFS_mex'
        G = PMA_EnumerationAlg_v11BFS_mex(cVf,Vf,iInitRep,phi,simple,...
            A,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    case 'tree_v12DFS_mex'
        [G,~] = PMA_EnumerationAlg_v12DFS_mex(Vf,E,G,id,cVf,Vf,iInitRep,...
            Am,Bf,B,Mf,M,displevel);
    case 'tree_v12BFS_mex'
        G = PMA_EnumerationAlg_v12BFS_mex(cVf,Vf,iInitRep,phi,...
            Am,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    %----------------------------------------------------------------------
    % analysis
    %----------------------------------------------------------------------
    case 'tree_v1_analysis'
        [G,~] = PMA_EnumerationAlg_v1_analysis(Vf,E,G,id,cVf,A,displevel,prenode);
    case 'tree_v8_analysis'
        [G,~] = PMA_EnumerationAlg_v8_analysis(Vf,E,G,id,cVf,Vf,iInitRep,...
            simple,A,Bf,B,Mf,M,displevel,prenode);
    case 'tree_v10_analysis'
        G = PMA_EnumerationAlg_v10_analysis(cVf,Vf,iInitRep,phi,simple,...
            A,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    case 'tree_v11DFS_analysis'
        [G,~] = PMA_EnumerationAlg_v11DFS_analysis(Vf,E,G,id,cVf,Vf,iInitRep,...
            simple,A,Bf,B,Mf,M,displevel,prenode);
    case 'tree_v11BFS_analysis'
        G = PMA_EnumerationAlg_v11BFS_analysis(cVf,Vf,iInitRep,phi,simple,...
            A,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    case 'tree_v12DFS_analysis'
        [G,~] = PMA_EnumerationAlg_v12DFS_analysis(Vf,E,G,id,cVf,Vf,iInitRep,...
            Am,Bf,B,Mf,M,displevel,prenode);
    case 'tree_v12BFS_analysis'
        G = PMA_EnumerationAlg_v12BFS_analysis(cVf,Vf,iInitRep,phi,...
            Am,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
    %----------------------------------------------------------------------
    % stochastic
    %----------------------------------------------------------------------
    case 'tree_v1_stochastic'
        M0 = zeros(1,sum(Vf),'uint8');
        for idx = 1:Nmax
            [G(idx,:),~] = PMA_StochasticAlg_v1(Vf,E,M0,id,A,cVf,displevel);
        end
    case 'tree_v8_stochastic'
        M0 = zeros(1,sum(Vf),'uint8');
        for idx = 1:Nmax
            [G(idx,:),~] = PMA_StochasticAlg_v8(Vf,E,M0,id,A,B,iInitRep,...
                cVf,Vf,simple,M,Mf,Bf,displevel);
        end
    case 'tree_v10_stochastic'
        for idx = 1:Nmax
            G(idx,:) = PMA_StochasticAlg_v10(cVf,Vf,iInitRep,phi,simple,...
            A,Bf,B,Mf,M,Pf,If,Im,IN,Ln,Nmax,displevel);
        end
    case 'tree_v11DFS_stochastic'
        error('need to implement')
    case 'tree_v11BFS_stochastic'
        error('need to implement')
    case 'tree_v12DFS_stochastic'
        error('need to implement')
    case 'tree_v12BFS_stochastic'
        error('need to implement')
    %----------------------------------------------------------------------
    case 'tree_test'
        % for testing new algorithms
    %----------------------------------------------------------------------
    otherwise
        error('algorithm not found')
end

% get all first column elements of G
F = G(:,1);

% find all the zero rows and remove
if contains(algorithm,'stochastic')
    % find any zero row
    G(F==0,:) = [];

else % enumerative methods
    % find the first zero row in G
    k = find(~F,1);

    % extract the nonzero rows of G
    if ~isempty(k)
        G = G(1:k-1,:);
    end
end

% find the number of graphs in G
N = size(G,1);

% sort as perfect matching
if sortFlag
    G = PMA_SortAsPerfectMatching(G);
end

% obtain perfect matching numbers
I = PM_pm2index(G);

% modify the node list and visualize the tree algorithm
if contains(algorithm,'analysis')

    % change data type
    nodelist = double(nodelist);

    % add dummy root node
    nodelist(nodelist == 0) = 1;
    nodelist = [0,nodelist];

    % fix order of parent vector
    [nodelist,pv] = PMA_FixParentPointers(nodelist);

    % sort label list
    labellist = [[0;0],labellist];
    labellist = labellist(:,pv);
    labellist(:,pv==1) = [];

    % sort feasible list
    feasiblelist = [0,feasiblelist];
    feasiblelist = feasiblelist(pv);
    feasiblelist(:,pv==1) = [];

    % create plot
    PMA_PlotTreeEnumerate

end

end