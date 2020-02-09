%--------------------------------------------------------------------------
% PMA_EX_A005814
% A005814, number of 3-regular (trivalent) labeled graphs on 2n vertices
% with multiple edges and loops allowed
% 2, 47, 4720, 1256395, 699971370, 706862729265, 1173744972139740, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 2; % number of nodes (currently completed for n = 3)
L = cellstr(string(dec2base((1:2*n)+9,36)))'; % labels
R.min = ones(1,2*n); R.max = ones(1,2*n); % replicate vector
P.min = repmat(3,1,2*n); P.max = repmat(3,1,2*n); % ports vector
NSC.simple = 0; % simple components
NSC.connected = 0; % connected graph required
NSC.loops = 1; % single loop allowed

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.algorithms.Nmax = 1e7;
opts.algorithms.isoNmax = 0;
opts.isomethod = 'py-igraph';
opts.parallel = false;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A005814
N = [2,47,4720,1256395,699971370,706862729265,1173744972139740];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))