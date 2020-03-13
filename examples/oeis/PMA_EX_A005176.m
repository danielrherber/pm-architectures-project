%--------------------------------------------------------------------------
% PMA_EX_A005176
% A005176, number of regular graphs with n nodes
% 1, 2, 2, 4, 3, 8, 6, 22, 26, 176, 546, 19002, 389454, 50314870, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A005176(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    n = varargin{1}; % extract n
    opts.plots.plotmax = 0;
    opts.displevel = 0;
    t1 = tic; % start timer
else
    clc; close all
    n = 9; % number of nodes (currently completed for n = 11)
end

L = {'A'}; % labels
R.min = n; R.max = n; % replicates
P.min = 0; P.max = n-1; % ports
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
NSC.userCatalogNSC = @(Subcatalogs,C,R,P,NSC,opts) subcatfunc(Subcatalogs,C,R,P,NSC,opts);

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A005176
N = [1,2,2,4,3,8,6,22,26,176,546,19002,389454,50314870];
n2 = N(n);

% compare number of graphs and create outputs
if isempty(varargin)
    disp("correct?")
    disp(string(isequal(length(G1),n2)))
else
    varargout{1} = n;
    varargout{2} = isequal(length(G1),n2);
    varargout{3} = toc(t1); % timer
end

end

% options
function opts = localOpts

opts.algorithm = 'tree_v11BFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end

function [Ls,Rs,Ps] = subcatfunc(~,Ls,Rs,Ps,~,~)
    % condition
    passed = sum(Rs~=0,2) == 1;

    % extract
    Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);
end