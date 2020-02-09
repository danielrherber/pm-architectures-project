%--------------------------------------------------------------------------
% PMA_EX_A005177
% A005177, number of connected regular graphs with n nodes
% 1, 1, 1, 2, 2, 5, 4, 17, 22, 167, 539, 18979, 389436, 50314796, ...
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
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(Subcatalogs,C,R,P,NSC,opts) subcatfunc(Subcatalogs,C,R,P,NSC,opts);

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11BFS';
opts.isomethod = 'python';
opts.parallel = 12;
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A005177
N = [1,1,1,2,2,5,4,17,22,167,539,18979,389436,50314796];
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
