%--------------------------------------------------------------------------
% PMA_EX_A000041
% A000041, a(n) is the number of partitions of n (the partition numbers)
% 1, 2, 3, 5, 7, 11, 15, 22, 30, 42, 56, 77, 101, 135, 176, 231, 297, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000041(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 15; % number of nodes (currently completed for n = 32)
end

L = {'O'}; % labels
R.min = n; R.max = n; % replicates
P.min = 2; P.max = 2; % ports
NSC.simple = 0; % multi-edges allowed
NSC.connected = 0; % connected graph not required
NSC.loops = 1; % loops allowed

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000041
N = [1,2,3,5,7,11,15,22,30,42,56,77,101,135,176,231,297,385,490,627,792,...
    1002,1255,1575,1958,2436,3010,3718,4565,5604,6842,8349,10143,12310];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e7;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'py-igraph';
opts.parallel = false; % only 1 catalog
opts.displevel = 1;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end