%--------------------------------------------------------------------------
% PMA_EX_A007721
% A007721, number of distinct degree sequences among all connected graphs
% with n nodes
% 1, 1, 2, 6, 19, 68, 236, 863, 3137, 11636, 43306, 162728, 614142, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A007721(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 7; % number of nodes (currently completed for n = 11)
end

if n == 1
    L = {'O'}; % labels
    R.min = 1; R.max = 1; % replicate vector
    P.min = 0; P.max = 0; % ports vector
else
    L = {'O'}; % labels
    R.min = n; R.max = n; % replicate vector
    P.min = 1; P.max = n-1; % ports vector
end
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) subcatfunc(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A007721
N = [1,1,2,6,19,68,236,863,3137,11636,43306,162728,614142,2330454];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = false;
opts.plots.plotmax = 0;
opts.plots.labelnumflag = false;

end

% only want to count catalogs condition
function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)

% zero ports (only need to count catalogs)
Ps = Ps.*0;

end