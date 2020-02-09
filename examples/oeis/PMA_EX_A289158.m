%--------------------------------------------------------------------------
% PMA_EX_A289158
% A289158, number of connected multigraphs with n nodes of degree at most 4
% and with at most double edges
% 1, 2, 7, 28, 112, 590, 3419, 23453, 178599, 1516692, 14083855, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 6; % number of nodes (currently completed for n = 9)
L = {'A'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 1; P.max = 4; % ports vector
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.multiedgeA = 2; % maximum double edges

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

% number of graphs based on OEIS A289158
N = [1,2,7,28,112,590,3419,23453,178599,1516692,14083855,142029043];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))