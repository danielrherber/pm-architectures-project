%--------------------------------------------------------------------------
% PMA_TEST_MultiedgeBounds.m
% Test function for multiedge bounded methods such as tree_v12DFS
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test number
testnum = 3;

switch testnum
    %----------------------------------------------------------------------
    case 1
    % problem specification
    L = {'R','G'}; % labels
    P = [3 3]; % ports
    R = [4 2]; % replicates
    NSC = []; % no constraints
    % NSC.simple = [0 0];
    %----------------------------------------------------------------------
    case 2
    % problem specification
    L = {'R'}; % labels
    P = [3]; % ports
    R = [10]; % replicates
    NSC.loops = 0;
    %----------------------------------------------------------------------
    case 3
    % problem specification
    L = {'R'}; % labels
    P = [6]; % ports
    R = [3]; % replicates
    NSC.simple = [0]; % maximum number of edges between L1 and another component
    NSC.connected = true;
    NSC.multiedgeA = 2;
    %----------------------------------------------------------------------
end

% generate graphs
G = PMA_UniqueFeasibleGraphs(L,R,P,NSC,localOpts);

function opts = localOpts

opts.algorithm = 'tree_v12DFS';
opts.parallel = 0;
opts.isomethod = 'python';
opts.plots.plotfun = 'matlab'; % 'circle' % 'bgl' % 'bio' % 'matlab'
opts.plots.plotmax = 5; % maximum number of graphs to display/save
opts.plots.labelnumflag = 0; % add replicate numbers when plotting
opts.plots.colorlib = 2; % color library
opts.plots.randomize = true;

end

% A\-A % then 0
% A-A % then 1
% A--A % then 2