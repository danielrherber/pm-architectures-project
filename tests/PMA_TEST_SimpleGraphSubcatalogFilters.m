%--------------------------------------------------------------------------
% PMA_TEST_SimpleGraphSubcatalogFilters.m
% Test function for PMA_ConnectedSubcatalogFilters
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test number
num = 2;

P.min = [1 2 3]; % ports vector
P.max = [1 3 10];
R.min = [1 1 1]; % replicates vector
R.max = [2 2 2];
L = {'R','G','B'}; % labels vector
NSC.connected = 1; % required for PMA_ConnectedSubcatalogFilters
NSC.loops = 0; % required for PMA_ConnectedSubcatalogFilters

% select test
switch num
    case 1 % don't use subcatalog filters
        NSC.simple = [0 1 1]; % required for PMA_ConnectedSubcatalogFilters
    case 2 % use subcatalog filters
        NSC.simple = [1 1 1]; % required for PMA_ConnectedSubcatalogFilters
end

% options
opts = currentopts;

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% options
function opts = currentopts
    opts.displevel = 2;
    opts.isomethod = 'python'; % option 'Matlab' is available in 2016b or later versions
    opts.plots.plotmax = 5; % maximum number of graphs to display/save
    opts.parallel =  12;
    opts.algorithm = 'tree_v11BFS';
    opts.isomethod = 'none';
end