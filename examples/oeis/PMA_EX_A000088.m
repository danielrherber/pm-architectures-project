%--------------------------------------------------------------------------
% PMA_EX_A000088
% A000088, number of graphs on n unlabeled nodes
% 1, 2, 4, 11, 34, 156, 1044, 12346, 274668, 12005168, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 7; % number of nodes (currently completed for n = 7)
L = {'A'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 0; P.max = n-1; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 1; % loops

% options
opts.plots.plotmax = 10;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.isomethod = 'python';
opts.parallel = 12;
opts.algorithms.isoNmax = inf;
opts.algorithms.Nmax = 1e7;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000088
N = [1,2,4,11,34,156,1044,12346,274668,12005168]-1; % missing 1 graph
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))