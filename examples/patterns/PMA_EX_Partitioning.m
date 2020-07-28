%--------------------------------------------------------------------------
% PMA_EX_Partitioning.m
% The partitioning pattern arises when there is a set of entities that need
% to be grouped into nonoverlapping subsets
%--------------------------------------------------------------------------
% D. Selva, B. Cameron, and E. Crawley, "Patterns in System Architecture
% Decisions," Syst Eng, vol. 19, no. 6, pp. 477–497, Nov. 2016, doi:
% 10.1002/sys.21370
% D. R. Herber, "Enhancements to the perfect matching approach for graph
% enumeration-based engineering challenges. In ASME 2020 International
% Design Engineering Technical Conferences, DETC2020-22774, Aug. 2020.
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

% case number (see switch statement below)
casenum = 3;

switch casenum
    %----------------------------------------------------------------------
    case 1 % original example from Selva2016

    Lin = {'LDR','RDR','RDM','IMG','SND','GPS'}; % labels
    part = [1 6]; % min and max hub number
    partcounts = [1 6]; % min and max counts in a given hub

    %----------------------------------------------------------------------
    case 2 % additional example from IDETC2020-22774

    Lin = {'A','B','C','D','E','F','G','H','I','J'}; % labels
    part = [1 10]; % min and max hub number
    partcounts = [1 10]; % min and max counts in a given hub

    %----------------------------------------------------------------------
    case 3 % constrained example from IDETC2020-22774

    Lin = {'A','B','C','D','E','F','G','H','I','J'}; % labels
    part = [2 5]; % min and max hub number
    partcounts = [2 3]; % min and max counts in a given hub

end

% combine
L = horzcat(Lin,{'P'}); % labels
NL = length(Lin);
R.min = [ones(NL,1);part(1)]; R.max = [ones(NL,1);part(2)]; % replicates
P.min = [ones(NL,1);partcounts(1)]; P.max = [ones(NL,1);partcounts(2)]; % ports

% network structure constraints
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
NSC.directA = ~blkdiag(ones(NL),ones(1)); % bipartite graph
NSC.userCatalogNSC = @PMA_BipartiteSubcatalogFilters;

% options
opts.plots.plotmax = 1;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;
opts.algorithm = 'tree_v12BFS_mex';
opts.isomethod = 'none'; % not needed
opts.parallel = true;
opts.algorithms.Nmax = 1e5;
opts.plots.saveflag = false;
opts.plots.outputtype = 'pdf';

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);