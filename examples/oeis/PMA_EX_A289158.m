%--------------------------------------------------------------------------
% PMA_EX_A289158
% A289158, number of connected multigraphs with n nodes of degree at most 4
% and with at most double edges
% 1, 2, 7, 28, 112, 590, 3419, 23453, 178599, 1516692, 14083855, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A289158(varargin)

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
    n = 1; % number of nodes (currently completed for n = 9)
end

L = {'A'}; % labels
R.min = n; R.max = n; % replicate vector
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.multiedgeA = 2; % maximum double edges
switch n
    case 1
        P.min = 0; P.max = 4; % ports vector
    otherwise
        P.min = 1; P.max = 4; % ports vector
end

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A289158
N = [1,2,7,28,112,590,3419,23453,178599,1516692,14083855,142029043];
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

opts.algorithm = 'tree_v12DFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end