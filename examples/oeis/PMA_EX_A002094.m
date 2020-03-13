%--------------------------------------------------------------------------
% PMA_EX_A002094
% A002094, number of unlabeled connected loop-less graphs on n nodes
% containing exactly one cycle (of length at least 2) and with all nodes
% of degree <= 4
% 0, 1, 2, 5, 10, 25, 56, 139, 338, 852, 2145, 5513, 14196, 36962, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A002094(varargin)

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
    n = 10; % number of nodes (currently completed for n = 14)
end

L = {'C'}; % labels
R.min = n; R.max = n; % replicates
P.min = 1; P.max = 4; % ports
NSC.simple = 0; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.Np = [2*n 2*n]; % tree + one cycle/multiedge bounds

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A002094
N = [0,1,2,5,10,25,56,139,338,852,2145,5513,14196,36962,96641];
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

opts.algorithm = 'tree_v11DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = 100;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end