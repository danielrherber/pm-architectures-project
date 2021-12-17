%--------------------------------------------------------------------------
% PMA_EX_A014395
% A014395, Number of multigraphs with 5 nodes and n edges
% 1, 3, 7, 17, 35, 76, 149, 291, 539, 974, 1691, 2874, 4730, 7620, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A014395(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 10; % number of lines (edges) (currently completed for n = 30)
end

L = {'V'};
R.min = 5; R.max = 5;
P.min = 0; P.max = n;
NSC.Np = [2*n 2*n]; % fixed number of lines (edges)
NSC.simple = 0; % multiedges allowed
NSC.connected = 0; % unconnected graph allowed
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A014395
N = [1,3,7,17,35,76,149,291,539,974,1691,2874,4730,7620,11986,18485,...
    27944,41550,60744,87527,124338,174403,241650,331153,448987,602853,...
    801943,1057615,1383343,1795578,2313595,2960656,3763879,4755505,...
    5972927,7460196,9267980];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS_mex';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'py-igraph';
opts.parallel = true;
% opts.plots.plotfun = 'matlab';
opts.plots.plotmax = 5;
opts.plots.colorlib = 0;

end