%--------------------------------------------------------------------------
% PMA_EX_A000041
% A000041, a(n) is the number of partitions of n (the partition numbers)
% 1, 2, 3, 5, 7, 11, 15, 22, 30, 42, 56, 77, 101, 135, 176, 231, 297, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 15; % number of nodes (currently completed for n = 29)
catalognum = 1;
switch catalognum
    case 1
        L = {'O'}; % labels
        R.min = n; R.max = n; % replicate vector
        P.min = 2; P.max = 2; % ports vector
        NSC.simple = 0; % multi-edges allowed
        NSC.connected = 0; % connected graph not required
        NSC.loops = 1; % loops allowed
    case 2 % alternative, less efficient catalog
        L = {'R','O'}; % labels
        R.min = [1;n]; R.max = [1;n]; % replicate vector
        P.min = [1;1]; P.max = [n;2]; % ports vector
        NSC.simple = 1; % simple components
        NSC.connected = 1; % connected graph
        NSC.loops = 0; % no loops
        opts.subcatalogfun = @(Sub,C,R,P,NSC,opts) subcatfunc(Sub,C,R,P,NSC,opts);
end

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.isomethod = 'py-igraph';
opts.parallel = 0;
opts.algorithms.Nmax = 1e7;
opts.algorithms.isoNmax = inf;
opts.displevel = 1;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000041
N = [1,2,3,5,7,11,15,22,30,42,56,77,101,135,176,231,297,385,490,627,792,...
    1002,1255,1575,1958,2436,3010,3718,4565,5604,6842,8349,10143,12310];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))

function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)
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