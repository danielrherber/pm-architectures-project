%--------------------------------------------------------------------------
% PMA_EX_A060542
% A060542, number of ways of dividing 3n labeled items into 3 unlabeled
% boxes with n items in each box
% 1, 15, 280, 5775, 126126, 2858856, 66512160, 1577585295, 37978905250, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A060542(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 3; % number of nodes (currently completed for n = 4)
end

L1 = 'BOX'; L2 = cellstr(string(dec2base((1:3*n)+9,36)))';
L = horzcat(L1,L2); % labels
R.min = [3;ones(3*n,1)]; R.max = R.min; % replicates
P.min = [n;ones(3*n,1)]; P.max = P.min; % ports
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
NSC.directA = double(~blkdiag(ones(1),ones(3*n)));
NSC.userCatalogNSC = @PMA_BipartiteSubcatalogFilters;

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A289158
N = [1,15,280,5775,126126,2858856,66512160,1577585295];
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