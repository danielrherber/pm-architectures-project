%--------------------------------------------------------------------------
% PMA_EX_A290778
% A290778, Number of connected undirected unlabeled loopless multigraphs
% with 4 vertices and n>0 edges
% 0, 2, 5, 11, 22, 37, 61, 95, 141, 203, 288, 393, 531, 704, 918, 1180, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A290778(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 15; % number of lines (edges) (currently completed for n = 45)
end

L = {'V'};
R.min = 4; R.max = 4;
P.min = 0; P.max = n;
NSC.Np = [2*n 2*n]; % fixed number of lines (edges)
NSC.simple = 0; % multiedges allowed
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A290778
N = [0,0,2,5,11,22,37,61,95,141,203,288,393,531,704,918,1180,1504,1887,...
    2351,2900,3546,4301,5187,6202,7379,8726,10262,12005,13987,16209,...
    18716,21521,24652,28135,32013,36291,41028,46244,51977,58262,65155,...
    72667,80872,89798];
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
opts.plots.plotmax = 5;
opts.plots.colorlib = 0;

end