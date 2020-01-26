%--------------------------------------------------------------------------
% PMA_EX_A000110
% A000110, Bell or exponential numbers: number of ways to partition a set
% of n labeled elements
% 1, 2, 5, 15, 52, 203, 877, 4140, 21147, 115975, 678570, 4213597, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 8; % number of elements (currently completed for n = 11)
L1 = cellstr(string(dec2base((1:n)+9,36)))'; L2{1} = 'PART';
L = horzcat(L1,L2);  % labels
R.min = [ones(n,1);1]; R.max = [ones(n,1);n]; % replicate vector
P.min = [ones(n,1);1]; P.max = [ones(n,1);n]; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
A = ones(n+1);
A(end,end) = 0; % no p-p connections
A(1:end-1,1:end-1) = 0; % no connections
NSC.A = A;

opts.subcatalogfun = @(Subcatalogs,C,R,P,NSC,opts) subcatfunc(Subcatalogs,C,R,P,NSC,opts);

% options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v11DFS_mex';
opts.isomethod = 'none'; % no needed for the partitioning problem
opts.parallel = 12;
opts.algorithms.Nmax = 1e7;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000110
N = [1, 2, 5, 15, 52, 203, 877, 4140, 21147, 115975, 678570, 4213597];
n2 = N(n);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))

% partition ports must equal element ports
function [Ls,Rs,Ps] = subcatfunc(L,Ls,Rs,Ps,~,~)
    % ports
    np = Rs.*Ps;

    % total number of ports (partitions)
    np1 = sum(np.*(Ls==length(L)),2);

    % total number of ports (elements)
    np2 = sum(np.*(Ls~=length(L)),2);

    % condition
    passed = np1 == np2;

    % extract
    Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);
end