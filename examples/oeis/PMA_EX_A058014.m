%--------------------------------------------------------------------------
% PMA_EX_A058014
% A058014, number of labeled trees with n+1 nodes such that the degrees of
% all nodes, excluding the first node, are odd
% 1, 1, 4, 13, 96, 541, 5888, 47545, 686080, 7231801, 130179072, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A058014(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 5; % number of nodes (currently completed for n = 9)
end

L1 = string(dec2base((1:n)+9,36));
L = vertcat('ROOT',L1); % labels
R.min = ones(n+1,1); R.max = R.min; % replicate vector
P.min = [1;ones(n,1)]; P.max = [n;repmat(n,n,1)]; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.Np = [2*n 2*n]; % tree condition
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) subcatfunc(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A058014
N = [1,1,4,13,96,541,5888,47545,686080,7231801,130179072,1695106117];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'none';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;

end

% odd degrees except first node condition
function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)

% condition
passed = all(mod(Ps(:,2:end),2),2);

% extract
Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);

end