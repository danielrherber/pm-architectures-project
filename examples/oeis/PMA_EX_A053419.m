%--------------------------------------------------------------------------
% PMA_EX_A053419
% A053419, number of graphs with loops (symmetric relations) with n edges
% 2, 5, 14, 38, 107, 318, 972, 3111, 10410, 36371, 132656, 504636, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A053419(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 7; % number of edges (currently completed for n = 11)
end

L = {'A'}; % labels
R.min = 1; R.max = 2*n; % replicates
P.min = 1; P.max = 2*n; % ports
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph
NSC.loops = 1; % single loop allowed
NSC.Np = [2*n 2*n];

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A053419
N = [2,5,14,38,107,318,972,3111,10410,36371,132656,504636,1998361];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end