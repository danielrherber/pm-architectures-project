%--------------------------------------------------------------------------
% PMA_EX_A056156
% A056156, number of connected bipartite graphs with n edges, no isolated
% vertices and a distinguished bipartite block, up to isomorphism
% 1, 2, 3, 7, 12, 32, 67, 181, 458, 1295, 3642, 10975, 33448, 106424, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A056156(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    n = varargin{1}; % extract n
    opts.plots.plotmax = 0;
    opts.displevel = 0;
    t1 = tic; % start timer
else
    clc; close all
    n = 8; % number of nodes (currently completed for n = 13)
end

L = {'A';'B'}; % labels
R.min = [1;1]; R.max = [n;n]; % replicates
P.min = [1;1]; P.max = [n;n]; % ports
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph not required
NSC.loops = 0; % no loops
NSC.directA = [0,1;1,0];
NSC.Np = [2*n 2*n]; % edge bounds
NSC.userCatalogNSC = @PMA_BipartiteSubcatalogFilters;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A056156
N = [1, 2, 3, 7, 12, 32, 67, 181, 458, 1295, 3642, 10975, 33448];
n2 = N(n);

% compare number of graphs and create outputs
if isempty(varargin)
    disp("correct?")
    disp(string(isequal(length(G1),n2)))
else
    varargout{1} = n;
    varargout{2} = isequal(length(G1),n2);
    varargout{3} = toc(t1); % timer
end

end

% options
function opts = localOpts

opts.algorithm = 'tree_v11BFS';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end