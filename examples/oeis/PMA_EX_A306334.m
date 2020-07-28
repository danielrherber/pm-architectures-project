%--------------------------------------------------------------------------
% PMA_EX_A306334
% A306334, a(n) is the number of different linear hydrocarbon molecules
% with n carbon atoms
% 1, 3, 4, 10, 18, 42, 84, 192, 409, 926, 2030, 4577, 10171, 22889, 51176, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A306334(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 6; % number of nodes (currently completed for n = 9)
end

L = {'C'}; % labels
R.min = n; R.max = n; % replicates
P.min = min(1,n-1); P.max = 4; % ports
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops
NSC.Np = [2*(n-1) 4*(n-1)+2]; % *not the best upper bound
NSC.userGraphNSC = @(pp,A,feasibleFlag) myGraphNSCfunc(pp,A,feasibleFlag);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A306334
N = [1,3,4,10,18,42,84,192,409,926,2030,4577,10171,22889,51176,115070,...
    257987,579868,1301664,2925209,];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end

function [pp,A,feasibleFlag] = myGraphNSCfunc(pp,A,feasibleFlag)

% only if the graph is currently feasible
if ~feasibleFlag
    return % exit, graph infeasible
end

% check if path graph
if any(sum(A~=0)>2)
    feasibleFlag = false;
    return % exit, graph infeasible
end

% check for cycles
cycleFlag = PMA_DetectCycle(logical(A));
if cycleFlag
    feasibleFlag = false;
    return % exit, graph infeasible
end

end