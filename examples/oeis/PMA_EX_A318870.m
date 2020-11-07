%--------------------------------------------------------------------------
% PMA_EX_A318870
% A318870, number of connected bipartite graphs on n unlabeled nodes with a
% distinguished bipartite block
% 2, 1, 2, 4, 10, 27, 88, 328, 1460, 7799, 51196, 422521, 4483460, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A318870(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 7; % number of nodes (currently completed for n = 10)
end

if n == 1
    L = {'B','W'}; % labels
    R.min = [0 0]; R.max = [1 1]; % replicate vector
    P.min = [0 0]; P.max = [0 0]; % ports vector
else
    L = {'B','W'}; % labels
    R.min = [1 1]; R.max = [n-1 n-1]; % replicate vector
    P.min = [1 1]; P.max = [n-1 n-1]; % ports vector
end
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.directA = ~eye(2);
NSC.Nr = [n n];
NSC.userCatalogNSC = @PMA_BipartiteSubcatalogFilters;

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A318870
N = [2,1,2,4,10,27,88,328,1460,7799,51196,422521,4483460,62330116];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS_mex';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;

end