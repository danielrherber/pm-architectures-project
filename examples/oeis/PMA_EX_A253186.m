%--------------------------------------------------------------------------
% PMA_EX_A253186
% A253186, Number of connected unlabeled loopless multigraphs with 3
% vertices and n>0 edges
% 0, 1, 2, 3, 4, 6, 7, 9, 11, 13, 15, 18, 20, 23, 26, 29, 32, 36, 39, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A253186(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 60; % number of lines (edges) (currently completed for n = 127)
    % NOTE: errors with q>127, likely due to data type issues
end

L = {'V'};
R.min = 3; R.max = 3;
P.min = 0; P.max = n;
NSC.Np = [2*n 2*n]; % fixed number of lines (edges)
NSC.simple = 0; % multiedges allowed
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A253186
n2 = floor(n/2) + floor((n^2 + 6)/12);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS_mex';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'py-igraph';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.colorlib = 0;

end