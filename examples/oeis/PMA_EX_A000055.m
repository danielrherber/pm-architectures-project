%--------------------------------------------------------------------------
% PMA_EX_A000055
% A000055, number of trees with n unlabeled nodes
% 1, 1, 1, 2, 3, 6, 11, 23, 47, 106, 235, 551, 1301, 3159, 7741, 19320, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000055(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 11; % number of nodes (currently completed for n = 16)
end

switch n
    case 1
        L = {'O'}; % labels
        R.min = 1; R.max = R.min; % replicate vector
        P.min = 0; P.max = P.min; % ports vector
    otherwise
        L = {'O'}; % labels
        R.min = n; R.max = n; % replicate vector
        P.min = 1; P.max = n-1; % ports vector
end
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.Nr = [n n];
NSC.Np = [2*(n-1) 2*(n-1)]; % tree condition

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000055
N = [1,1,1,2,3,6,11,23,47,106,235,551,1301,3159,7741,19320,48629,123867,...
    317955,823065,2144505,5623756,14828074,39299897,104636890,279793450];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;

end