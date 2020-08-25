%--------------------------------------------------------------------------
% PMA_EX_A000272
% A000272, number of trees on n labeled nodes: n^(n-2)
% 1, 1, 3, 16, 125, 1296, 16807, 262144, 4782969, 100000000, 2357947691,...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000272(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 6; % number of nodes (currently completed for n = 9)
end

L = cellstr(string(dec2base((1:n)+9,36)));
R.min = ones(n,1); R.max = R.min; % replicate vector
P.min = repmat(min(n-1,1),n,1); P.max = repmat(n-1,n,1); % ports vector
opts.isomethod = 'none'; % not needed

NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops
NSC.Np = [2*(n-1) 2*(n-1)]; % tree condition

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000272
n2 = n^(n-2);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = 0;
opts.isomethod = 'none';
opts.parallel = true; % 6;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end