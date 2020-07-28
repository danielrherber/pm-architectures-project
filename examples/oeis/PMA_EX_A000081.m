%--------------------------------------------------------------------------
% PMA_EX_A000081
% A000081, number of unlabeled rooted trees with n nodes
% 1, 1, 2, 4, 9, 20, 48, 115, 286, 719, 1842, 4766, 12486, 32973, 87811,...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000081(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 9; % number of nodes (currently completed for n = 15)
end

switch n
    case 1
        L = {'R'}; % labels
        R.min = 1; R.max = R.min; % replicate vector
        P.min = 0; P.max = P.min; % ports vector
    otherwise
        L = {'R','O'}; % labels
        R.min = [1 n-1]; R.max = [1 n-1]; % replicate vector
        P.min = [1 1]; P.max = [n-1 n-1]; % ports vector
end
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.Nr = [n n];
NSC.Np = [2*(n-1) 2*(n-1)]; % tree condition

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000081
N = [1,1,2,4,9,20,48,115,286,719,1842,4766,12486,32973,87811];
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