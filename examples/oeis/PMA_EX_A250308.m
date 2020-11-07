%--------------------------------------------------------------------------
% PMA_EX_A250308
% A250308, number of unlabeled unrooted trees on 2n vertices with all
% vertices of odd degree
% 1, 1, 2, 3, 7, 13, 32, 74, 192, 497, 1379, 3844, 11111, 32500, 96977, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A250308(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 6; % number of nodes (currently completed for n = 10)
end

L = {'B'}; % labels
R.min = 2*n; R.max = R.min; % replicate vector
P.min = 1; P.max = 2*n-1; % ports vector
NSC.Np = [2*(2*n-1) 2*(2*n-1)]; % tree condition
NSC.simple = 1; % no multiedges
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) subcatfunc(L,Ls,Rs,Ps,NSC,opts);

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A250308
N = [1,1,2,3,7,13,32,74,192,497,1379,3844,11111,32500,96977,292600,...
    894353,2758968,8590147,26947946];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = 1000;
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