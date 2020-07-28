%--------------------------------------------------------------------------
% PMA_EX_A000014
% A000014, number of series-reduced trees with n nodes
% 1, 1, 0, 1, 1, 2, 2, 4, 5, 10, 14, 26, 42, 78, 132, 249, 445, 842, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000014(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 11; % number of nodes (currently completed for n = 20)
end

switch n
    case {1,2}
        L = {'B'};
        R.min = n; R.max = R.min;
        P.min = n-1; P.max = P.min;
    otherwise
        L = {'B','B'};
        R.min = [2 0];
        R.max = [n-1 n];
        P.min = [1 3];
        P.max = [1 n-1];
end
NSC.Nr = [n n];
NSC.Np = [2*(n-1) 2*(n-1)]; % tree condition
NSC.simple = 1; % no multiedges
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000014
N = [1,1,0,1,1,2,2,4,5,10,14,26,42,78,132,249,445,842,1561,2988,5671,10981];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.isoNmax = inf;
opts.algorithms.Nmax = 1e6;
opts.isomethod = 'py-igraph';
opts.parallel = true;
opts.plots.plotfun = 'matlab';
opts.plots.plotmax = 5;
opts.plots.saveflag = false;
opts.plots.labelnumflag = false;
opts.plots.colorlib = 0;
opts.plots.titleflag = false;
opts.plots.outputtype = 'pdf';

end