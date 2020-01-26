%--------------------------------------------------------------------------
% PMA_EX_A261919
% A261919, number of n-node unlabeled graphs without isolated nodes or
% endpoints (i.e., no nodes of degree 0 or 1)
% 0, 0, 1, 3, 11, 62, 510, 7459, 197867, 9808968, 902893994, ...
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
P.min = 2; P.max = n-1; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops

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

% number of graphs based on OEIS A261919
N = [0,0,1,3,11,62,510,7459,197867,9808968,902893994];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))