%--------------------------------------------------------------------------
% PMA_EX_A000081
% A000081, number of unlabeled rooted trees with n nodes
% 1, 1, 2, 4, 9, 20, 48, 115, 286, 719, 1842, 4766, 12486, 32973, 87811,...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 9; % number of nodes (currently completed for n = 14)
L = {'R','O'}; % labels
R.min = [1 n-1]; R.max = [1 n-1]; % replicate vector
P.min = [1 1]; P.max = [n-1 n-1]; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.bounds.Nr = [n n];
NSC.bounds.Np = [2*(n-1) 2*(n-1)]; % tree condition upper bound

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.isomethod = 'python';
opts.parallel = 12;
opts.algorithms.isoNmax = inf;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000081
N = [1,1,2,4,9,20,48,115,286,719,1842,4766,12486,32973,87811];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))