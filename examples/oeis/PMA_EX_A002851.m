%--------------------------------------------------------------------------
% PMA_EX_A002851
% A002851, number of unlabeled trivalent (or cubic) connected graphs with
% 2n nodes
% 0, 1, 2, 5, 19, 85, 509, 4060, 41301, 510489, 7319447, 117940535, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 6; % number of nodes (currently completed for n = 8)
L = {'A'}; % labels
R.min = 2*n; R.max = 2*n; % replicate vector
P.min = 3; P.max = 3; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.algorithms.Nmax = 1e7;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = 0;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A002851
N = [0,1,2,5,19,85,509,4060,41301,510489,7319447,117940535,2094480864];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))