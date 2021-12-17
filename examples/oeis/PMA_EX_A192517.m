%--------------------------------------------------------------------------
% PMA_EX_A192517
% A192517, Table read by antidiagonals: T(q,p) = number of multigraphs with
% p vertices and q edges, with no loops allowed (p >= 1, q >= 0)
% 1     1     1     1     1     1     1     1     1     1
% 0     1     1     1     1     1     1     1     1     1
% 0     1     2     3     3     3     3     3     3     3
% 0     1     3     6     7     8     8     8     8     8
% 0     1     4    11    17    21    22    23    23    23
% 0     1     5    18    35    52    60    64    65    66
% 0     1     7    32    76   132   173   197   206   210
% 0     1     8    48   149   313   471   588   645   671
% 0     1    10    75   291   741  1303  1806  2121  2283
% 0     1    12   111   539  1684  3510  5509  7042  7964
% 0     1    14   160   974  3711  9234 16677 23615 28494
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A192517(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    p = 6; % number of points (vertices, order)
    q = 8; % number of lines (edges)
end

L = {'V'};
R.min = p; R.max = p;
P.min = 0; P.max = q;
NSC.Np = [2*q 2*q]; % fixed number of lines (edges)
NSC.simple = 0; % multiedges allowed
NSC.connected = 0; % unconnected graph allowed
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A192517 (only up to (p,q) = (10,10))
N = [1 0 0 0 0 0 0 0 0 0 0;...
    1 1 1 1 1 1 1 1 1 1 1;...
    1 1 2 3 4 5 7 8 10 12 14;...
    1 1 3 6 11 18 32 48 75 111 160;...
    1 1 3 7 17 35 76 149 291 539 974;...
    1 1 3 8 21 52 132 313 741 1684 3711;...
    1 1 3 8 22 60 173 471 1303 3510 9234;...
    1 1 3 8 23 64 197 588 1806 5509 16677;...
    1 1 3 8 23 65 206 645 2121 7042 23615;...
    1 1 3 8 23 66 210 671 2283 7964 28494];
n2 = N(p,q+1);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'py-igraph';
opts.parallel = true;
opts.plots.plotmax = 4;
opts.plots.colorlib = 0;

end