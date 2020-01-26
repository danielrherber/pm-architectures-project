%--------------------------------------------------------------------------
% PMA_EX_A000142
% A000142, generate all permutations of n vertices
% 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 8; % number of nodes (currently completed for n = 9)
catalognum = 1;
switch catalognum
    case 1
        L = ['STR';string(dec2base((1:n)+9,36))]; % labels
        R.min = ones(n+1,1); R.max = R.min; % replicate vector
        P.min = ones(n+1,1); P.max = [1;repmat(2,n,1)]; % ports vector
    case 2 % old catalog with fixed ports
        L = ['STR';'END';cellstr(strcat(dec2base((1:n)+9,36)))]; % labels
        R.min = ones(n+2,1); R.max = R.min; % replicates vector
        P = [1;1;repmat(2,n,1)]; % ports vector
end
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph not required
NSC.loops = 0; % loops
opts.subcatalogfun = @(Subcatalogs,C,R,P,NSC,opts) subcatfunc(Subcatalogs,C,R,P,NSC,opts);

% options
opts.algorithms.Nmax = uint64(1e6);
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.parallel = 12;
opts.isomethod = 'none'; % needed

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000142
tic
G2 = perms(1:n);
n2 = length(G2);
toc

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
