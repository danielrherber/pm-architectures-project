%--------------------------------------------------------------------------
% PMA_EX_A005177
% A005177, number of connected regular graphs with n nodes
% 1, 1, 1, 2, 2, 5, 4, 17, 22, 167, 539, 18979, 389436, 50314796, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A005177(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 8; % number of nodes (currently completed for n = 12)
end

L = {'A'}; % labels
R.min = n; R.max = n; % replicates
P.min = 0; P.max = n-1; % ports
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) subcatfunc(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A005177
N = [1,1,1,2,2,5,4,17,22,167,539,18979,389436,50314796];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end

% regular graph condition
function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)
% condition
passed = sum(Rs~=0,2) == 1;

% extract
Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);
end