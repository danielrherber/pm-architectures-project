%--------------------------------------------------------------------------
% PMA_EX_A001710
% A001710, number of necklaces one can make with n distinct beads: n!
% bead permutations, divide by two to represent flipping the necklace over,
% divide by n to represent rotating the necklace
% number of connected labeled graphs on n nodes with exactly 1 cycle
% 1, 1, 3, 12, 60, 360, 2520, 20160, 181440, 1814400, 19958400, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A001710(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 6; % number of nodes (currently completed for n = 11)
end

L = cellstr(strcat(dec2base((1:n+1)+9,36))); % labels
R.min = ones(n+1,1); R.max = R.min; % replicates vector
P.min = repmat(min(2,n),n+1,1); P.max = P.min; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A001710
N = [1,1,3,12,60,360,2520,20160,181440,1814400,19958400,239500800];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 2e7;
opts.isomethod = 'none'; % not needed
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end