%--------------------------------------------------------------------------
% PMA_EX_A006820
% A006820, number of connected regular simple graphs of degree 4 (or
% quartic graphs) with n nodes
% 0, 0, 0, 0, 1, 1, 2, 6, 16, 59, 265, 1544, 10778, 88168, 805491, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A006820(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
	clc; close all
    n = 9; % number of nodes (currently completed for n = 12)
end

L = {'A'}; % labels
R.min = n; R.max = n; % replicates
P.min = 4; P.max = 4; % ports
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A006820
N = [0,0,0,0,1,1,2,6,16,59,265,1544,10778,88168,805491,8037418,86221634];
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