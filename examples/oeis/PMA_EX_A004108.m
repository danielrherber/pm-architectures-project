%--------------------------------------------------------------------------
% PMA_EX_A004108
% A004108, number of n-node unlabeled connected graphs without endpoints
% 0, 0, 1, 3, 11, 61, 507, 7442, 197772, 9808209, 902884343, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 8; % number of nodes (currently completed for n = 8)
L = {'A'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 2; P.max = n-1; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = 1000;
opts.isomethod = 'python';
opts.parallel = true;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A004108
N = [0, 0, 1, 3, 11, 61, 507, 7442, 197772, 9808209, 902884343];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))