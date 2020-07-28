%--------------------------------------------------------------------------
% PMA_EX_A005333
% A005333, number of 2-colored connected labeled graphs with n vertices of
% the first color and n vertices of the second color
% 1, 5, 205, 36317, 23679901, 56294206205, 502757743028605, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A005333(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 2; % number of nodes (currently completed for n = 4)
end

L = vertcat(cellstr(strcat('A',dec2base((1:n)+9,36))),...
    cellstr(strcat('B',dec2base((1:n)+9,36))))'; % labels
R.min = ones(2*n,1);
R.max = ones(2*n,1);
P.min = ones(2*n,1);
P.max = repmat(n,2*n,1);
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph
NSC.loops = 0; % no loops
NSC.directA = double(~blkdiag(ones(n),ones(n)));
NSC.userCatalogNSC = @PMA_BipartiteSubcatalogFilters;

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A005333
N = [1, 5, 205, 36317, 23679901, 56294206205, 502757743028605];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'python';
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;
opts.plots.colorlib = @CustomColorLib;

end

% custom color library
function c = CustomColorLib(L)
c = zeros(length(L),3); % initialize
for k = 1:length(L) % go through each label and assign a color
    switch upper(L{k}(1))
        case 'A'
            ct = [244,67,54]/255; % red 500
        case 'B'
            ct = [3,169,244]/255; % lightBlue 500
    end
    c(k,:) = ct; % assign
end
end