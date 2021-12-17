%--------------------------------------------------------------------------
% PMA_EX_A191646
% A191646, Triangle read by rows: T(q,p) = number of connected multigraphs
% with p >= 0 edges and 1 <= q <= p+1 vertices, with no loops allowed
% 1      1      1      1      1      1      1      1      1      1      1
% 0      1      0      0      0      0      0      0      0      0      0
% 0      1      1      0      0      0      0      0      0      0      0
% 0      1      2      2      0      0      0      0      0      0      0
% 0      1      3      5      3      0      0      0      0      0      0
% 0      1      4     11     11      6      0      0      0      0      0
% 0      1      6     22     34     29     11      0      0      0      0
% 0      1      7     37     85    110     70     23      0      0      0
% 0      1      9     61    193    348    339    185     47      0      0
% 0      1     11     95    396    969   1318   1067    479    106      0
% 0      1     13    141    771   2445   4457   4940   3294   1279    235
% 0      1     15    203   1411   5746  13572  19753  17927  10218   3413
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A191646(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    p = 7; % number of points (vertices, order)
    q = 9; % number of lines (edges)
end

L = {'V'};
R.min = p; R.max = p;
P.min = 0; P.max = q;
NSC.Np = [2*q 2*q]; % fixed number of lines (edges)
NSC.simple = 0; % multiedges allowed
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A191646 (only up to (p,q) = (11,11))
N = [1 0 0 0 0 0 0 0 0 0 0 0;...
    1 1 1 1 1 1 1 1 1 1 1 1;...
    1 0 1 2 3 4 6 7 9 11 13 15;...
    1 0 0 2 5 11 22 37 61 95 141 203;...
    1 0 0 0 3 11 34 85 193 396 771 1411;...
    1 0 0 0 0 6 29 110 348 969 2445 5746;...
    1 0 0 0 0 0 11 70 339 1318 4457 13572;...
    1 0 0 0 0 0 0 23 185 1067 4940 19753;...
    1 0 0 0 0 0 0 0 47 479 3294 17927;...
    1 0 0 0 0 0 0 0 0 106 1279 10218;...
    1 0 0 0 0 0 0 0 0 0 235 3413];
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
opts.plots.plotmax = 0;
opts.plots.colorlib = 0;

end