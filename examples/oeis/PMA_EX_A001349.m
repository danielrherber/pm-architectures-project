%--------------------------------------------------------------------------
% PMA_EX_A001349
% A001349, number of connected graphs with n nodes
% 1, 1, 2, 6, 21, 112, 853, 11117, 261080, 11716571, ...
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
P.min = 1; P.max = n-1; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

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

% number of graphs based on OEIS A001349
N = [1,1,2,6,21,112,853,11117,261080,11716571];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))