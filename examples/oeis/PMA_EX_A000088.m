%--------------------------------------------------------------------------
% PMA_EX_A000088
% A000088, number of graphs on n unlabeled nodes
% 1, 2, 4, 11, 34, 156, 1044, 12346, 274668, 12005168, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000088(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 5; % number of nodes (currently completed for n = 7)
end

L = {'A'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 0; P.max = n-1; % ports vector
NSC.simple = 1; % no multiedges
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000088
N = [1,2,4,11,34,156,1044,12346,274668,12005168];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.isoNmax = inf;
opts.algorithms.Nmax = 1e7;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;

end