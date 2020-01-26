%--------------------------------------------------------------------------
% PMA_EX_A001710
% A001710, number of necklaces one can make with n distinct beads: n!
% bead permutations, divide by two to represent flipping the necklace over,
% divide by n to represent rotating the necklace
% number of connected labeled graphs on n nodes with exactly 1 cycle
% 1, 1, 3, 12, 60, 360, 2520, 20160, 181440, 1814400, 19958400, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 9; % number of nodes (currently completed for n = 11)
L = cellstr(strcat(dec2base((1:n)+9,36))); % labels
R.min = ones(n,1); R.max = R.min; % replicates vector
P.min = repmat(2,n,1); P.max = P.min; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.Nmax = 2e7;
opts.isomethod = 'none'; % not needed

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A001710
n2 = factorial(n-1)/2;

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))