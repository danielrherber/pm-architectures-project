%--------------------------------------------------------------------------
% PMA_EX_Downselecting.m
% The downselecting pattern is motivated by the tasks of the system
% architect that require choosing a subset of among a set of candidate
% entities
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
casenum = 2;

L = {'LDR','RDR','RDM','IMG','SND','GPS','SAR','SPM'}; % labels
NL = length(L); % number of labels
R.min = zeros(NL,1); R.max = ones(NL,1); % replicates
P.min = repelem(0,NL,1); P.max = P.min; % ports

switch casenum
    %----------------------------------------------------------------------
    case 1 % original example from Selva2016

    %----------------------------------------------------------------------
    case 2 % constrained example from IDETC2020-22774
    NSC.PenaltyValue = 10;
    NSC.PenaltyMatrix = [4,5,5,3,3,6,4,4];
    %----------------------------------------------------------------------
end

% network structure constraints
NSC.loops = 1; % loops allowed
NSC.directA = zeros(NL); % no connections allowed

% options
opts.plots.plotmax = 10;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;
opts.algorithm = 'tree_v12BFS_mex';
opts.isomethod = 'none'; % not needed
opts.parallel = false;
opts.algorithms.Nmax = 1e5;
opts.plots.saveflag = false;
opts.plots.outputtype = 'pdf';

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);