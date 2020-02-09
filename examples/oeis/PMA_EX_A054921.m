%--------------------------------------------------------------------------
% PMA_EX_A054921
% A054921, number of connected unlabeled symmetric relations (graphs with
% loops) having n nodes
% 2, 3, 10, 50, 354, 3883, 67994, 2038236, 109141344, 10693855251, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 4; % number of nodes (currently completed for n = 6)
L = {'A'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 1; P.max = n+1; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 1; % single loop allowed

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.algorithms.Nmax = 1e7;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A054921
N = [2,3,10,50,354,3883,67994,2038236,109141344,10693855251];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))