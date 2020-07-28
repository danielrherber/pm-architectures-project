%--------------------------------------------------------------------------
% PMA_EX_A001187
% A001187, number of connected labeled graphs with n nodes
% 1, 1, 4, 38, 728, 26704, 1866256, 251548592, 66296291072, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A001187(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 4; % number of nodes (currently completed for n = 6)
end

L = cellstr(strcat(dec2base((1:n)+9,36))); % labels
R.min = ones(n,1); R.max = ones(n,1); % replicates
P.min = min(1,n-1)*ones(n,1); P.max = (n-1)*ones(n,1); % ports
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A001187
N = [1,1,4,38,728,26704,1866256,251548592,66296291072];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end