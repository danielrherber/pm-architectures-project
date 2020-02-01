%--------------------------------------------------------------------------
% PMA_EX_A056156
% A056156, number of connected bipartite graphs with n edges, no isolated
% vertices and a distinguished bipartite block, up to isomorphism
% 1, 2, 3, 7, 12, 32, 67, 181, 458, 1295, 3642, 10975, 33448, 106424, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 7; % number of nodes (currently completed for n = 11)
L = {'A';'B'}; % labels
R.min = [1;1]; R.max = [n;n]; % replicate vector
P.min = [1;1]; P.max = [n;n]; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph not required
NSC.loops = 0; % no loops
NSC.A = [0,1;1,0];
NSC.bounds.Np = [2*n 2*n]; % edge bounds

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A056156
N = [1, 2, 3, 7, 12, 32, 67, 181, 458, 1295, 3642, 10975, 33448];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))