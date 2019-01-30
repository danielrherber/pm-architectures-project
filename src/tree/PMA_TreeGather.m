%--------------------------------------------------------------------------
% PMA_TreeGather.m
% Complete problem set up and use a particular method to generate graphs
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [G,I,N] = PMA_TreeGather(Ln,P,R,NSC,opts,phi)

    % set this number based on user value or predefined large value
    if isfield(opts,'Nmax')
        Nmemory = opts.Nmax;
    else
        Nmemory = 1e7;
    end

    % number of perfect matchings
    Npm = 2*prod(1:2:(P'*R-1)); % factor of 2 needed for tree_v10

    % maximum number of graphs to preallocate for or generate
    % [in some cases, the code greatly slows if this number is succeeded]
    if contains(opts.algorithm,'stochastic')
        Nmax = Nmemory;
    else
        Nmax = min(Npm,Nmemory);
    end

    % vector when all ports are unconnected
    Vf = uint8(NSC.Vfull);

    % expand reduced potential adjacency matrix
    A = PMA_ExpandPossibleAdj(NSC.A,R,NSC);

    % check if B was provided
    if NSC.flag.Bflag
        if ~isfield(NSC,'B')
            B = PMA_CreateBMatrix(NSC.Bind,R,NSC);
        else
            error('please specify NSC.Bind, not NSC.B')
        end
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
    counts = NSC.counts;
    M = NSC.M;
    displevel = uint8(opts.displevel);
    algorithm = opts.algorithm;
    
    % default option to use PMA_SortAsPerfectMatching
    % [change in the algorithm structure below if necessary]
    sortFlag = 1;
    
    % initialize dispstat for overwritable messages to the command line
    if (displevel > 1)
        dispstat('','init');
    end

    % global variable used to save the tree structure (optional addition)
    if contains(algorithm,'analysis')
        global node nodelist %#ok
        node = 1; % 
        nodelist = []; % 
        prenode = 0; % 
    end

    % use the specified algorithm
    switch algorithm
        %------------------------------------------------------------------
        % tree
        %------------------------------------------------------------------
        case 'tree_v1'
            [G,~] = PMA_EnumerateAlg1(Vf,E,G,id,A,cVf,displevel);
        case 'tree_v8'
            [G,~] = PMA_EnumerateAlg8(Vf,E,G,id,A,B,iInitRep,cVf,...
                Vf,counts,M,Mf,Bf,displevel);
        case 'tree_v10'
            G = PMA_EnumerateAlg10(cVf,Vf,iInitRep,counts,...
                phi,Ln,A,B,M,Nmax,Mf,Bf,displevel);
        %------------------------------------------------------------------
        % mex
        %------------------------------------------------------------------
        case 'tree_v1_mex'
            [G,~] = PMA_EnumerateAlg1_mex(Vf,E,G,id,A,cVf,displevel);
        case 'tree_v8_mex'
            [G,~] = PMA_EnumerateAlg8_mex(Vf,E,G,id,A,B,iInitRep,cVf,...
                Vf,counts,M,Mf,Bf,displevel);
        case 'tree_v10_mex'
            G = PMA_EnumerateAlg10_mex(cVf,Vf,iInitRep,counts,...
                phi,Ln,A,B,M,Nmax,Mf,Bf,displevel);
        %------------------------------------------------------------------
        % analysis
        %------------------------------------------------------------------
        case 'tree_v1_analysis'
            [G,~] = PMA_EnumerateAlg1_Analysis(Vf,E,G,id,A,cVf,displevel,prenode);
        case 'tree_v8_analysis'
            [G,~] = PMA_EnumerateAlg8_Analysis(Vf,E,G,id,A,B,iInitRep,cVf,...
                Vf,counts,M,Mf,Bf,displevel,prenode);
        %------------------------------------------------------------------
        % stochastic
        %------------------------------------------------------------------
        case 'tree_v1_stochastic'
            M0 = zeros(1,sum(Vf),'uint8');
            for idx = 1:Nmax
                [G(idx,:),~] = PMA_StochasticAlg1(Vf,E,M0,id,A,cVf,displevel);
            end
        case 'tree_v8_stochastic'
            M0 = zeros(1,sum(Vf),'uint8');
            for idx = 1:Nmax
                [G(idx,:),~] = PMA_StochasticAlg8(Vf,E,M0,id,A,B,iInitRep,...
                    cVf,Vf,counts,M,Mf,Bf,displevel);
            end
        case 'tree_v10_stochastic'
            for idx = 1:Nmax
                G(idx,:) = PMA_StochasticAlg10(cVf,Vf,iInitRep,counts,...
                    phi,Ln,A,B,M,Nmax,Mf,Bf,displevel);
            end
        %------------------------------------------------------------------
        case 'tree_test'
            % for testing new algorithms
        %------------------------------------------------------------------
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
        nodelist(nodelist == 0) = 1;
        nodelist = [0,nodelist];
        PMA_PlotTreeEnumerate
    end
    
end