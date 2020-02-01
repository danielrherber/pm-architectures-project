%--------------------------------------------------------------------------
% PMA_EX_A00014
% A000014, number of series-reduced trees with n nodes
% 0, 1, 1, 0, 1, 1, 2, 2, 4, 5, 10, 14, 26, 42, 78, 132, 249, 445, 842, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 10; % number of nodes (currently completed for n = 15) % still not working
L = {'B','B'};
R.min = [2 0];
R.max = [n-1 n];
P.min = [1 3];
P.max = [1 n-1];
NSC.bounds.Nr = [n n];
NSC.bounds.Np = [2*(n-1) 2*(n-1)]; % tree condition upper bound
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% options
opts.plots.plotfun = 'bgl';
opts.plots.plotmax = 0;
opts.plots.saveflag = false;
opts.plots.labelnumflag = false;
opts.plots.colorlib = 0;
opts.plots.titleflag = false;
opts.plots.outputtype = 'pdf';
opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.isoNmax = inf;
opts.algorithms.Nmax = uint64(1e6);
opts.isomethod = 'py-igraph';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000262
N = [1,1,0,1,1,2,2,4,5,10,14,26,42,78,132,249,445,842,1561,2988,5671,10981];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))