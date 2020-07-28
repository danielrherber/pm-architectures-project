%--------------------------------------------------------------------------
% PMA_EX_A054921
% A054921, number of connected unlabeled symmetric relations (graphs with
% loops) having n nodes
% 2, 3, 10, 50, 354, 3883, 67994, 2038236, 109141344, 10693855251, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A054921(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 4; % number of nodes (currently completed for n = 6)
end

L = {'A'}; % labels
R.min = n; R.max = n; % replicates
P.min = min(1,n-1); P.max = n+1; % ports
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 1; % single loop allowed

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A054921
N = [2,3,10,50,354,3883,67994,2038236,109141344,10693855251];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e7;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end