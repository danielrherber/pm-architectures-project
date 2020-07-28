%--------------------------------------------------------------------------
% PMA_EX_A002905
% A002905, number of connected graphs with n edges
% 1, 1, 3, 5, 12, 30, 79, 227, 710, 2322, 8071, 29503, 112822, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A002905(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 8; % number of edges (currently completed for n = 12)
end

L = {'A'}; % labels
R.min = floor(1/2*(sqrt(8*n + 1) + 1)); R.max = n+1; % replicates
P.min = 1; P.max = 2*n-1; % ports
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops
NSC.Np = [2*n 2*n]; % edge bounds

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A002905
N = [1, 1, 3, 5, 12, 30, 79, 227, 710, 2322, 8071, 29503, 112822];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e5;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end