%--------------------------------------------------------------------------
% PMA_EX_A053419
% A053419, number of graphs with loops (symmetric relations) with n edges
% 2, 5, 14, 38, 107, 318, 972, 3111, 10410, 36371, 132656, 504636, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 11; % number of edges (currently completed for n = )
L = {'A'}; % labels
R.min = 1; R.max = 2*n; % replicate vector
P.min = 1; P.max = 2*n; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph
NSC.loops = 1; % single loop allowed
NSC.bounds.Np = [2*n 2*n];

% options
opts.plots.plotmax = 0;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A053419
N = [2,5,14,38,107,318,972,3111,10410,36371,132656,504636,1998361];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))