%--------------------------------------------------------------------------
% PMA_EX_A005333
% A005333, number of 2-colored connected labeled graphs with n vertices of
% the first color and n vertices of the second color
% 1, 5, 205, 36317, 23679901, 56294206205, 502757743028605, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 2; % number of nodes (currently completed for n = 4)
L = vertcat(cellstr(strcat('A',dec2base((1:n)+9,36))),...
    cellstr(strcat('B',dec2base((1:n)+9,36))))'; % labels
R.min = ones(2*n,1);
R.max = ones(2*n,1);
P.min = ones(2*n,1);
P.max = repmat(n,2*n,1);
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.directA = double(~blkdiag(ones(n),ones(n)));

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.isomethod = 'python';
opts.parallel = true;
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A005333
N = [1, 5, 205, 36317, 23679901, 56294206205, 502757743028605];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))