%--------------------------------------------------------------------------
% PMA_EX_A000598
% A000598, number of rooted ternary trees with n nodes; number of n-carbon
% alkyl radicals C(n)H(2n+1) ignoring stereoisomers
% 1, 1, 2, 4, 8, 17, 39, 89, 211, 507, 1238, 3057, 7639, 19241, 48865, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 10; % number of nodes (currently completed for n = 14)
L = {'RC','C'}; % labels
R.min = [1 n-1]; R.max = [1 n-1]; % replicate vector
P.min = [1 1]; P.max = [3 4]; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.bounds.Np = [2*(n-1) 2*(n-1)]; % tree condition

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000598
N = [1,1,2,4,8,17,39,89,211,507,1238,3057,7639,19241,48865,124906];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))