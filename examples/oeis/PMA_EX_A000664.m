%--------------------------------------------------------------------------
% PMA_EX_A000664
% A000664, number of graphs with n edges
% 1, 1, 2, 5, 11, 26, 68, 177, 497, 1476, 4613, 15216, 52944, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 9; % number of edges (currently completed for n = 12)
L = {'A'}; % labels
R.min = floor(1/2*(sqrt(8*n + 1) + 1)); R.max = 2*n; % replicate vector
P.min = 1; P.max = 2*n-1; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
NSC.bounds.Np = [2*n 2*n]; % edge bounds

% options
opts.algorithms.Nmax = uint64(1e5);
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.isomethod = 'python';
opts.parallel = 12;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000664
N = [1,2,5,11,26,68,177,497,1476,4613,15216,52944,193367,740226];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))

