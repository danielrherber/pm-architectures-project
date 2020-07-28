%--------------------------------------------------------------------------
% PMA_EX_A000110
% A000110, Bell or exponential numbers: number of ways to partition a set
% of n labeled elements
% 1, 2, 5, 15, 52, 203, 877, 4140, 21147, 115975, 678570, 4213597, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000110(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 8; % number of elements (currently completed for n = 11)
end

L1 = cellstr(string(dec2base((1:n)+9,36)))'; L2{1} = 'PART';
L = horzcat(L1,L2); % labels
R.min = [ones(n,1);1]; R.max = [ones(n,1);n]; % replicates
P.min = [ones(n,1);1]; P.max = [ones(n,1);n]; % ports
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
A = ones(n+1);
A(end,end) = 0; % no part-part connections
A(1:end-1,1:end-1) = 0; % no element-element connections
NSC.directA = A;
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) PMA_BipartiteSubcatalogFilters(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000110
N = [1, 2, 5, 15, 52, 203, 877, 4140, 21147, 115975, 678570, 4213597];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e7;
opts.isomethod = 'none'; % no needed for the partitioning problem
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end