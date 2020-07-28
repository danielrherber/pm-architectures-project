%--------------------------------------------------------------------------
% PMA_EX_A108246
% A108246, number of labeled 2-regular graphs with no multiple edges, but
% loops are allowed (i.e., each vertex is endpoint of two (usual) edges or 
% one loop)
% 1, 1, 2, 8, 38, 208, 1348, 10126, 86174, 819134, 8604404, 98981944, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A108246(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 8; % number of nodes (currently completed for n = 10)
end

L = cellstr(strcat(dec2base((1:n)+9,36))); % labels
R.min = ones(n,1); R.max = ones(n,1); % replicates
P.min = repelem(2,n,1); P.max = repelem(2,n,1); % ports
% NSC.multiedgeA = ones(n); % no multiedges
NSC.simple = 1; % no multiedges
NSC.loops = 1; % single loop allowed

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A108246
N = [1,1,2,8,38,208,1348,10126,86174,819134,8604404,98981944,1237575268];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'none'; % none needed with certain methods
opts.parallel = false;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end