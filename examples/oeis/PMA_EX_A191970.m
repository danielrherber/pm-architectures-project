%--------------------------------------------------------------------------
% PMA_EX_A191970
% A191970, number of connected graphs with n edges with loops allowed
% 2, 2, 6, 12, 33, 93, 287, 940, 3309, 12183, 47133, 190061, 796405, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 8; % number of edges (currently completed for n = )
L = {'A'}; % labels
R.min = 1; R.max = n+1; % replicate vector
P.min = 1; P.max = 2*n; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 1; % single loop allowed
NSC.bounds.Np = [2*n 2*n];

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A191970
N = [2,2,6,12,33,93,287,940,3309,12183,47133,190061,796405];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))