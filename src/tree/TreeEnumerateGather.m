function [M,I,N] = TreeEnumerateGather(P,R,NSC,opts)

Vfull = uint8(NSC.Vfull);
A = uint8(NSC.A);

% set this number based on user value or predefined large value
if isfield(opts,'Nmax')
	Nmemory = opts.Nmax;
else
    Nmemory = 1e8;
end

% number of perfect matchings
Npm = prod(1:2:(P'*R-1));

% maximum number of graphs to preallocate for, code greatly slows if this
% number is succeeded
Nmax = min(Npm,Nmemory);

% id is used to keep track of the number of graphs found
id = 0;

% initialize empty edge set
E = uint8([]);

% initialize zero matrix where edge sets will be placed
M = zeros(Nmax,sum(Vfull),'uint8');

% expand A to get the potential connected components adjacency matrix 
p.A = ExpandPossibleAdj(A,R,NSC);

% Ac = ones(size(p.A),'uint8'); 
Ac = p.A; % this can be just Ac

% save ports vector to p structure
p.P = P;

% save replicates vector to p structure
p.R = R;

% vertex number + 1 in the connected ports graph of the first element of 
% each component
p.pI = uint8(cumsum(Vfull)+1);

% vertex number in the connected component graph of the first components of
% a particular component type
p.cI = uint8(cumsum(p.R)-p.R+1);

% save constraints
p.NSC.self = NSC.self;
p.NSC.necessary = NSC.necessary;
p.NSC.counts = NSC.counts;

% initialize dispstat for overwritable messages to the command line
dispstat('','init');

% global variable used to save the tree structure (optional addition)
global node nodelist
node = 1; % 
nodelist = []; % 
prenode = 0; % 

switch opts.algorithm
    %----------------------------------------------------------------------
    case 'tree_v1'
        sortFlag = 1;
        [M,~] = TreeEnumerateCreatev1(Vfull,E,M,id,p);
    %----------------------------------------------------------------------
    case 'tree_v2'
        % create vector for v2 improvement 1
        v2 = ones(size(p.pI),'uint8');
        for i = 1:length(p.P)
            v2(p.cI(i)+1:p.cI(i)+p.R(i)-1) = uint8(0);
        end
        sortFlag = 1;
        [M,~] = TreeEnumerateCreatev2(Vfull,E,M,id,p,v2);
    %----------------------------------------------------------------------
    case 'tree_v3'
        p.Vfull = Vfull;
        p.v3 = ones(size(p.pI),'uint8');
        sortFlag = 1;
        [M,~] = TreeEnumerateCreatev3(Vfull,E,M,id,p);
    %----------------------------------------------------------------------
    case 'tree_v4'
        p.Vfull = Vfull;
        p.v3 = ones(size(p.pI),'uint8');
        sortFlag = 1;
        [M,~] = TreeEnumerateCreatev4(Vfull,E,M,id,p,Ac,opts.displevel);
    %----------------------------------------------------------------------
    case 'tree_v5'
        p.Vfull = Vfull;
%         p.pI = uint8(cumsum(Vfull)-1);
        p.pI = cumsum(Vfull)-Vfull;
        p.v3 = ones(size(p.pI),'uint8');
        p.PR = sum(p.Vfull);
        p.cI = uint8(cumsum(p.R)); % last component
        sortFlag = 0;
        [M,~] = TreeEnumerateCreatev5(Vfull,E,M,id,p,Ac,p.NSC.counts,p.NSC.necessary);
    %----------------------------------------------------------------------
    case 'tree_v6'
        p.Vfull = Vfull;
        p.v3 = ones(size(p.pI),'uint8');
        sortFlag = 1;
        [M,~] = TreeEnumerateCreatev4(Vfull,E,M,id,p,Ac,opts.displevel);
    %----------------------------------------------------------------------
    
    case 'tree_v1_analysis'
        sortFlag = 1;
        [M,~] = TreeEnumerateCreatev1Analysis(Vfull,E,M,id,p,prenode);
        nodelist(nodelist == 0) = 1;
        nodelist = [0,nodelist];
        plotTreeEnumerate
    %----------------------------------------------------------------------
    case 'tree_v2_analysis'
        % create vector for v2 improvement 1
        v2 = ones(size(p.pI),'uint8');
        for i = 1:length(p.P)
            v2(p.cI(i)+1:p.cI(i)+p.R(i)-1) = uint8(0);
        end
        sortFlag = 1;
        [M,~] = TreeEnumerateCreatev2Analysis(Vfull,E,M,id,p,v2,prenode);
        nodelist(nodelist == 0) = 1;
        nodelist = [0,nodelist];
        plotTreeEnumerate
    %----------------------------------------------------------------------
    case 'tree_v3_analysis'
        p.Vfull = Vfull;
        p.v3 = ones(size(p.pI),'uint8');
        [M,~] = TreeEnumerateCreatev3Analysis(Vfull,E,M,id,p,prenode);
        nodelist(nodelist == 0) = 1;
        nodelist = [0,nodelist];
        plotTreeEnumerate
    %----------------------------------------------------------------------
    case 'tree_v4_analysis'
        p.Vfull = Vfull;
        p.v3 = ones(size(p.pI),'uint8');
        sortFlag = 1;
        [M,~] = TreeEnumerateCreatev4Analysis(Vfull,E,M,id,p,Ac,prenode);
        nodelist(nodelist == 0) = 1;
        nodelist = [0,nodelist];
        plotTreeEnumerate
    %----------------------------------------------------------------------
    otherwise
        error('algorithm not found')
end

% if opts.limited == 0   
% elseif opts.limited == 1
%     [M,~] = TreeEnumerateCreate2(Vfull,E,M,id,prenode);
% end

% get all first column elements of M
A = M(:,1);

% find the first zero row in M
k = find(~A,1);

% extract the nonzero rows of M
if ~isempty(k)
    M = M(1:k-1,:); 
end

% find the number of graphs in M
N = size(M,1);

I = ones(N,1);
parfor (i = 1:N, opts.parallel)
    O = M(i,:);
    if sortFlag
        O = SortAsPerfectMatching(O); % sort M to make them perfect matchings
    end
    I(i) = InversePerfectMatchings(O);
    M(i,:) = O;
end

%% potentially remove, no two perfect indentical PMs should be found
% disp(N)
% 
% % extract on the unique rows
% % M is already sorted
% [M,IA] = unique(M,'rows');
% 
% % extract the PM numbers of the unique rows
% I = I(IA);
% 
% % find the number of graphs in M
% N = size(M,1);
% 
% disp(N)

end