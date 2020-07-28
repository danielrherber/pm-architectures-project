%--------------------------------------------------------------------------
% PMA_EX_A008406
% A008406, triangle T(n,k) read by rows, giving number of graphs with n
% nodes (n >= 1) and k edges (0 <= k <= n(n-1)/2)
% 1,
% 1,1,
% 1,1,1,1,
% 1,1,2,3,2,1,1, [graphs with 4 nodes and from 0 to 6 edges]
% 1,1,2,4,6,6,6,4,2,1,1,
% 1,1,2,5,9,15,21,24,24,21,15,9,5,2,1,1,
% 1,1,2,5,10,21,41,65,97,131,148,148,131,97,65,41,21,10,5,2,1,1,
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 5; % number of nodes
k = 6; % number of edges
L = {'A'}; % labels
R.min = n; R.max = n; % replicates
P.min = 0; P.max = n-1; % ports
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % loops
NSC.Np = [2*k 2*k]; % edge bounds

% options
opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e5;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 10;
opts.plots.labelnumflag = false;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);