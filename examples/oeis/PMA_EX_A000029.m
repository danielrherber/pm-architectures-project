%--------------------------------------------------------------------------
% PMA_EX_A000029
% A000029, number of necklaces with n beads of 2 colors, allowing turning
% over (these are also called bracelets)
% 2, 3, 4, 6, 8, 13, 18, 30, 46, 78, 126, 224, 380, 687, 1224, 2250, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function varargout = PMA_EX_A000029(varargin)

% options (see function below)
opts = localOpts;

% parse inputs
if ~isempty(varargin)
    flag = 'inputs'; PMA_EX_OEIScommon; %#ok<NASGU>
else
    clc; close all
    n = 7; % number of nodes (currently completed for n = 20)
end

switch n
    case 1
        L = {'B','W'};
        R.min = [0 0]; R.max = [n n];
        P.min = [0 0]; P.max = P.min;
    otherwise
        L = {'B','W'};
        R.min = [0 0]; R.max = [n n];
        P.min = [2 2]; P.max = P.min;
end
NSC.Nr = [n n];
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops

% obtain all unique, feasible graphs
[G1,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A000029
N = [2,3,4,6,8,13,18,30,46,78,126,224,380,687,1224,2250,4112,7685,14310,...
    27012,50964,96909,184410];
n2 = N(n);

% compare number of graphs and create outputs
flag = 'outputs'; PMA_EX_OEIScommon; %#ok<NASGU>

end

% options
function opts = localOpts

opts.algorithm = 'tree_v12BFS';
opts.algorithms.Nmax = 1e6;
opts.algorithms.isoNmax = inf;
opts.isomethod = 'py-igraph';
opts.parallel = false; % only 1 catalog
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;
opts.plots.colorlib = @CustomColorLib;

end

% custom color library
function c = CustomColorLib(L)
c = zeros(length(L),3); % initialize
for k = 1:length(L) % go through each label and assign a color
    switch upper(L{k})
        case 'W'
            ct = [0.9 0.9 0.9];
        case 'B'
            ct = [0.4 0.4 0.4];
    end
    c(k,:) = ct; % assign
end
end