%--------------------------------------------------------------------------
% PMA_TEST_SubcatalogConstraints.m
% Test function for linear penalty and satisfaction constraints on catalogs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test number
testnum = 5;

switch testnum
    %----------------------------------------------------------------------
    % linear penalty constraints
    case 1
        n = 4; % maximum number of replicates for each type
        L = {'A','B','C'}; % labels

        NSC.PenaltyMatrix(1,:) = [1 2 3];
        NSC.PenaltyMatrix(2,:) = [3 2 1];
        NSC.PenaltyValue(1) = 5;
        NSC.PenaltyValue(2) = 8;
    case 2
        n = 2; % maximum number of replicates for each type
        L = {'A','B'}; % labels

        NSC.PenaltyMatrix(1,:) = [1 2];
        NSC.PenaltyMatrix(2,:) = [2 1];
        NSC.PenaltyValue(1) = 3;
        NSC.PenaltyValue(2) = 4;
    case 3
        n = 10; % maximum number of replicates for each type
        L = {'A','B'}; % labels

        NSC.PenaltyMatrix(1,:) = [1 1];
        NSC.PenaltyMatrix(2,:) = [1 1];
        NSC.PenaltyValue(1) = 6;
        NSC.PenaltyValue(2) = 8;
    %----------------------------------------------------------------------
    % linear satisfaction constraints
    case 4
        n = 11; % maximum number of replicates for each type
        L = {'A','B'}; % labels

        NSC.SatisfactionMatrix(1,:) = [1 1];
        NSC.SatisfactionMatrix(2,:) = [1 1];
        NSC.SatisfactionValue(1) = 20;
        NSC.SatisfactionValue(2) = 6;
    %----------------------------------------------------------------------
    % both constraints
    case 5
        n = 100; % maximum number of replicates for each type
        L = {'A','B'}; % labels

        NSC.SatisfactionMatrix = [1 1];
        NSC.SatisfactionValue = 8;
        NSC.PenaltyMatrix = [1 1];
        NSC.PenaltyValue = 10;
    %----------------------------------------------------------------------
end

% common problem elements
P.min = repelem(2,1,length(L)); P.max = repelem(2,1,length(L));
R.min = zeros(1,length(L)); R.max = repelem(n,length(L),1);
NSC.directA = zeros(length(L)); NSC.loops = 1;

% generate graphs
G = PMA_UniqueFeasibleGraphs(L,R,P,NSC,localOpts);

% options
function opts = localOpts

opts.algorithm = 'tree_v12DFS';
opts.parallel = 0;
opts.isomethod = 'python';
opts.plots.plotfun = 'matlab'; % 'circle' % 'bgl' % 'bio' % 'matlab'
opts.plots.plotmax = 10; % maximum number of graphs to display/save
opts.plots.labelnumflag = 0; % add replicate numbers when plotting
opts.plots.colorlib = 2; % color library
opts.plots.randomize = true;
opts.displevel = 1;

end