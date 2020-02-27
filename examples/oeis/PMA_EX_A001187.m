%--------------------------------------------------------------------------
% PMA_EX_A001187
% A001187, number of connected labeled graphs with n nodes
% 1, 1, 4, 38, 728, 26704, 1866256, 251548592, 66296291072, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 5; % number of nodes (currently completed for n = 6)
L = cellstr(strcat(dec2base((1:n)+9,36))); % labels
R.min = ones(n,1); R.max = ones(n,1); % replicate vector
P.min = ones(n,1); P.max = (n-1)*ones(n,1); % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.algorithms.Nmax = 1e7;
opts.isomethod = 'python';
opts.parallel = true;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A001187
N = [1,1,4,38,728,26704,1866256,251548592,66296291072];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))