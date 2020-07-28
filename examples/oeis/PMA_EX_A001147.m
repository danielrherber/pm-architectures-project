%--------------------------------------------------------------------------
% PMA_EX_A001147
% A001147, number of perfect matchings in the complete graph K(2n)
% double factorial of odd numbers: a(n) = (2*n-1)!! = 1*3*5*...*(2*n-1)
% 1, 3, 15, 105, 945, 10395, 135135, 2027025, 34459425, 654729075, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A001147(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 12; % number of nodes (currently completed for n = 16)
end

L = cellstr(strcat(dec2base((1:n)+9,36))); % labels
R.min = ones(n,1); R.max = R.min; % replicate vector
P.min = ones(n,1); P.max = P.min; % ports vector
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % loops allowed

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% compare to MFX 52301
G2 = PM_perfectMatchings(n);
n2 = size(G2,1);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e7;
opts.isomethod = 'none';
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end