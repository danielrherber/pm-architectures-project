%--------------------------------------------------------------------------
% PMA_EX_A003049
% A003049, number of connected Eulerian graphs with n unlabeled nodes
% 1, 0, 1, 1, 4, 8, 37, 184, 1782, 31026, 1148626, 86539128, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A003049(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 1; % number of nodes (currently completed for n = 8)
end

if n == 1
    L = {'O'}; % labels
    R.min = 1; R.max = 1; % replicate vector
    P.min = 0; P.max = 0; % ports vector
else
    L = {'O'}; % labels
    R.min = n; R.max = n; % replicate vector
    P.min = 1; P.max = n; % ports vector
end
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) subcatfunc(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A003049
N = [1,0,1,1,4,8,37,184,1782,31026,1148626,86539128,12798435868];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;

end

% even degrees condition
function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)

% condition
passed = all(~mod(Ps,2),2);

% extract
Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);

end