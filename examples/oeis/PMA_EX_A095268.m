%--------------------------------------------------------------------------
% PMA_EX_A095268
% A095268, number of distinct degree sequences among all n-vertex graphs
% with no isolated vertices
% 0, 1, 2, 7, 20, 71, 240, 871, 3148, 11655, 43332, 162769, 614198, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A095268(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 5; % number of nodes (currently completed for n = 11)
end

L = {'O'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 1; P.max = max(1,n-1); % ports vector
NSC.simple = 1; % simple components
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) subcatfunc(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A095268
N = [0,1,2,7,20,71,240,871,3148,11655,43332,162769,614198,2330537];
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