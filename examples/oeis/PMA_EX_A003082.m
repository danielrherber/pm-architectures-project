%--------------------------------------------------------------------------
% PMA_EX_A003082
% A003082, Number of multigraphs with 4 nodes and n edges
% 1, 3, 6, 11, 18, 32, 48, 75, 111, 160, 224, 313, 420, 562, 738, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A003082(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 30; % number of lines (edges) (currently completed for n = 60)
end

L = {'V'};
R.min = 4; R.max = 4;
P.min = 0; P.max = n;
NSC.Np = [2*n 2*n]; % fixed number of lines (edges)
NSC.simple = 0; % multiedges allowed
NSC.connected = 0; % unconnected graph allowed
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A003082
N = [1,3,6,11,18,32,48,75,111,160,224,313,420,562,738,956,1221,1550,...
    1936,2405,2958,3609,4368,5260,6279,7462,8814,10356,12104,14093,...
    16320,18834,21645,24783,28272,32158,36442,41187,46410,52151,58443,...
    65345,72864,81078,90012,99718,110240,121651,133965,147277,161622,...
    177065,193662,211502,230608,251093,273003,296418,321408,348079,...
    376464,406696,438834,472974,509201,547640,588336,631443,677034,...
    725223,776112,829846,886483,946200,1009086,1075274,1144884,1218083,...
    1294944,1375668,1460361,1549177,1642256,1739788,1841862,1948705];
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
opts.plots.plotmax = 0;
opts.plots.colorlib = 0;

end