%--------------------------------------------------------------------------
% PMA_EX_A134818
% A134818, number of connected multigraphs with n nodes of degree at most 4
% and with at most triple edges
% 1, 3, 9, 37, 146, 772, 4449, 30307, 228605, 1921464, 17652327, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 6; % number of nodes (currently completed for n = 8)
L = {'A'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 1; P.max = 4; % ports vector
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.multiedgeA = 3; % maximum triple edges

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v12DFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A134818
N = [1,3,9,37,146,772,4449,30307,228605,1921464,17652327,176162548];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))