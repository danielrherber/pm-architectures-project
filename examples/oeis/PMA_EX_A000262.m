%--------------------------------------------------------------------------
% PMA_EX_A000262
% A000262, generate all labeled-rooted skinny-tree forests on n vertices
% 1, 3, 13, 73, 501, 4051, 37633, 394353, 4596553, 58941091, 824073141, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000262(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 7; % number of nodes (currently completed for n = 9)
end

catalognum = 1;
switch catalognum
    case 1
        L1 = string(dec2base((1:n)+9,36));
        L = vertcat('ROOT',L1); % labels
        R.min = ones(n+1,1); R.max = R.min; % replicate vector
        P.min = [1;ones(n,1)]; P.max = [n;repmat(2,n,1)]; % ports vector
        opts.isomethod = 'none'; % not needed
    case 2 % old catalog with fixed ports
        L1 = string(dec2base((1:n)+9,36));
        L = vertcat('ROOT',L1,'END'); % labels
        R.min = [ones(n+1,1);n]; R.max = R.min; % replicate vector
        P.min = [n;repmat(2,n,1);1]; P.max = P.min; % ports vector
        opts.isomethod = 'python'; % needed
end
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops
NSC.Nr = [n+1 n+1];
NSC.Np = [2*n 2*n]; % tree condition

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000262
n2 = 0;
for k = 1:n
   n2 = n2 + nchoosek(n,k)*nchoosek(n-1,k-1)*factorial(n-k);
end

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e5;
opts.algorithms.isoNmax = 0;
opts.isomethod = 'none';
opts.parallel = true; % 6;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

end