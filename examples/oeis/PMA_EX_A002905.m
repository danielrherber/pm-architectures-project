%--------------------------------------------------------------------------
% PMA_EX_A002905
% A002905, number of connected graphs with n edges
% 1, 1, 3, 5, 12, 30, 79, 227, 710, 2322, 8071, 29503, 112822, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 13; % number of edges (currently completed for n = 12)
L = {'A'}; % labels
R.min = floor(1/2*(sqrt(8*n + 1) + 1)); R.max = n+1; % replicate vector
P.min = 1; P.max = 2*n-1; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops
NSC.bounds.Np = [2*n 2*n]; % edge bounds

% options
opts.algorithms.Nmax = uint64(1e5);
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.Nmax = 1e7;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A002905
N = [1, 1, 3, 5, 12, 30, 79, 227, 710, 2322, 8071, 29503, 112822];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))