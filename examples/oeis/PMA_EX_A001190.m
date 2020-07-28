%--------------------------------------------------------------------------
% PMA_EX_A001190
% A001190, Wedderburn-Etherington numbers: unlabeled binary rooted trees
% (every node has out-degree 0 or 2) with n endpoints (and 2n-1 nodes in
% all)
% 1, 1, 1, 2, 3, 6, 11, 23, 46, 98, 207, 451, 983, 2179, 4850, 10905, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A001190(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 8; % number of endpoints nodes (currently completed for n = 12)
end

L = {'R','E','P'}; % labels
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
directA = ones(3);
directA(1,1) = 0; % no R-R
directA(2,2) = 0; % no E-E
NSC.directA = directA;
switch n
    case 1
        P.min = [1 1 3]; P.max = [2 1 3]; % ports
        R.min = [1 n 0]; R.max = [1 n 0]; % replicates
    otherwise
        P.min = [2 1 3]; P.max = [2 1 3]; % ports
        R.min = [1 n n-2]; R.max = [1 n n-2]; % replicates
end

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A001190
N = [1,1,1,2,3,6,11,23,46,98,207,451,983,2179,4850,10905,24631,56011,...
    127912,293547,676157,1563372,3626149,8436379,19680277,46026618,...
    107890609,253450711,596572387,1406818759,3323236238,7862958391,...
    18632325319,44214569100];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = 3000;
opts.isomethod = 'python';
opts.parallel = false;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end