%--------------------------------------------------------------------------
% PMA_EX_A002854
% A002854, number of unlabeled Euler graphs with n nodes; number of
% unlabeled two-graphs with n nodes; number of unlabeled switching classes
% of graphs with n nodes; number of switching classes of unlabeled signed
% complete graphs on n nodes; number of Seidel matrices of order n
% 1, 1, 2, 3, 7, 16, 54, 243, 2038, 33120, 1182004, 87723296, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A002854(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 6; % number of nodes (currently completed for n = 8)
end

L = {'O'}; % labels
R.min = n; R.max = n; % replicate vector
P.min = 0; P.max = n; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) subcatfunc(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A002854
N = [1,1,2,3,7,16,54,243,2038,33120,1182004,87723296,12886193064];
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

end

% even degrees condition
function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)

% condition
passed = all(~mod(Ps,2),2);

% extract
Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);

end