%--------------------------------------------------------------------------
% PMA_EX_A191970
% A191970, number of connected graphs with n edges with loops allowed
% 2, 2, 6, 12, 33, 93, 287, 940, 3309, 12183, 47133, 190061, 796405, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A191970(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 7; % number of edges (currently completed for n = 10)
end

L = {'A'}; % labels
R.min = 1; R.max = n+1; % replicates
P.min = 1; P.max = 2*n; % ports
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 1; % single loop allowed
NSC.Np = [2*n 2*n];

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A191970
N = [2,2,6,12,33,93,287,940,3309,12183,47133,190061,796405];
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
opts.plots.randomize = true;

end