%--------------------------------------------------------------------------
% PMA_EX_A002094
% A002094, number of unlabeled connected loop-less graphs on n nodes
% containing exactly one cycle (of length at least 2) and with all nodes
% of degree <= 4
% 0, 1, 2, 5, 10, 25, 56, 139, 338, 852, 2145, 5513, 14196, 36962, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 10; % number of nodes (currently completed for n = 14)
L = {'C'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 1; P.max = 4; % ports vector
NSC.simple = 0; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.Np = [2*n 2*n]; % tree + one cycle/multiedge bounds

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = 100;
opts.isomethod = 'python';
opts.parallel = true;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A002094
N = [0,1,2,5,10,25,56,139,338,852,2145,5513,14196,36962,96641];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))