%--------------------------------------------------------------------------
% PMA_EX_A000262
% A000262, generate all labeled-rooted skinny-tree forests on n vertices
% 1, 3, 13, 73, 501, 4051, 37633, 394353, 4596553, 58941091, 824073141, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 7; % number of nodes (currently completed for n = 9)
catalognum = 1;
switch catalognum
    case 1
        L1 = string(dec2base((1:n)+9,36));
        L = vertcat('ROOT',L1); % labels
        R.min = ones(n+1,1); R.max = R.min; % replicate vector
        P.min = [1;ones(n,1)]; P.max = [n;repmat(2,n,1)]; % ports vector
        opts.isomethod = 'none'; % not needed
    case 2 % old catalog with fixed ports
        L1 = string(dec2base((1:n)+9,36));
        L = vertcat('ROOT',L1,'END'); % labels
        R.min = [ones(n+1,1);n]; R.max = R.min; % replicate vector
        P.min = [n;repmat(2,n,1);1]; P.max = P.min; % ports vector
        opts.isomethod = 'python'; % needed
end
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph not required
NSC.loops = 0; % loops
NSC.bounds.Nr = [n+1 n+1];
NSC.bounds.Np = [2 2*(n-1+1)]; % tree condition upper bound
opts.subcatalogfun = @(Subcatalogs,C,R,P,NSC,opts) subcatfunc(Subcatalogs,C,R,P,NSC,opts);

% options
opts.algorithms.Nmax = uint64(1e5);
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.isoNmax = 0;
opts.isomethod = 'none';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000262
n2 = 0;
for k = 1:n
   n2 = n2 + nchoosek(n,k)*nchoosek(n-1,k-1)*factorial(n-k);
end

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))

function [Ls,Rs,Ps] = subcatfunc(L,Ls,Rs,Ps,NSC,opts)
    % initialize
    failed = false(size(Ps,1),1);

    % check tree graph condition
    for idx = 1:size(Ps,1)
        Pst = repelem(Ps(idx,:),Rs(idx,:));
        n = length(Pst);
        c1 = sum(Pst);
        c2 = 2*(n-1);
        if c1 ~= c2
            failed(idx) = true;
            continue
        end
    end

    % remove failed subcatalogs
    Ls(failed,:) = [];
    Ps(failed,:) = [];
    Rs(failed,:) = [];
end
