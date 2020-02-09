%--------------------------------------------------------------------------
% PMA_EX_A005176
% A005176, number of regular graphs with n nodes
% 1, 2, 2, 4, 3, 8, 6, 22, 26, 176, 546, 19002, 389454, 50314870, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 9; % number of nodes (currently completed for n = 11)
L = {'A'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 0; P.max = n-1; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(Subcatalogs,C,R,P,NSC,opts) subcatfunc(Subcatalogs,C,R,P,NSC,opts);

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.isomethod = 'python';
opts.parallel = true;
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A005176
N = [1,2,2,4,3,8,6,22,26,176,546,19002,389454,50314870]-1; % missing one graph
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))

function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)
    % condition
    passed = sum(Rs~=0,2) == 1;

    % extract
    Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);
end