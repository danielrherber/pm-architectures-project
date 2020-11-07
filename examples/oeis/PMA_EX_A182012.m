%--------------------------------------------------------------------------
% PMA_EX_A182012
% A182012, number of graphs on 2n unlabeled nodes all having odd degree
% 1, 3, 16, 243, 33120, 87723296, 3633057074584, 1967881448329407496, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A182012(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 3; % number of nodes (currently completed for n = 4)
end

L = {'O'}; % labels
R.min = 2*n; R.max = 2*n; % replicate vector
P.min = 1; P.max = 2*n-1; % ports vector
NSC.simple = 1; % simple components
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) subcatfunc(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A182012
N = [1,3,16,243,33120,87723296,3633057074584,1967881448329407496];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS_mex';
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;

end

% odd degrees condition
function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)

% condition
passed = all(mod(Ps,2)|(Ps==0),2);

% extract
Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);

end