%--------------------------------------------------------------------------
% PMA_EX_Assigning.m
% The assigning pattern has to do with assignments or allocations between
% two predefined sets of entities
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

switch casenum
    %----------------------------------------------------------------------
    case 1 % original example from Selva2016

    Lin = {'LDR','RDR','RDM','IMG','SND','GPS'}; % list of instruments
    Lor = {'GEO','SUN','POL'}; % list of orbits

    % bounds on instrument replicates
    P1min = zeros(length(Lin),1); P1max = repelem(length(Lor),length(Lin),1);

    % bounds on instruments per orbit
    P2min = zeros(length(Lor),1); P2max = repelem(length(Lin),length(Lor),1);
    %----------------------------------------------------------------------
    case 2 % constrained example from IDETC2020-22774

    Lin = {'LDR','RDR','RDM','IMG','SND','GPS'}; % list of instruments
    Lor = {'GEO','SUN','POL'}; % list of orbits

    % bounds on instrument replicates
    P1min = [1 1 1 1 1 1]; P1max = [1 1 1 1 1 1];

    % bounds on instruments per orbit
    P2min = [0 0 0]; P2max = [3 3 3];
    %----------------------------------------------------------------------
end

% combine instruments and orbits specifications
L = horzcat(Lin,Lor);
N1 = length(Lin); N2 = length(Lor); NL = N1 + N2;
P.min = [P1min(:);P2min(:)]; P.max = [P1max(:);P2max(:)];
R.min = ones(NL,1); R.max = R.min;

% network structure constraints
NSC.loops = 0; % no loops
NSC.directA = ~blkdiag(ones(N1),ones(N2)); % bipartite graph
NSC.simple = 1; % no multiedges
NSC.userCatalogNSC = @PMA_BipartiteSubcatalogFilters;

% options
opts.plots.plotmax = 10;
opts.plots.labelnumflag = false;
opts.algorithm = 'tree_v12BFS_mex';
opts.isomethod = 'none';
opts.parallel = false;
opts.algorithms.Nmax = 1e2;
opts.plots.colorlib = @CustomColorLib;
opts.plots.randomize = true;
opts.plots.titleflag = false;
opts.plots.saveflag = false;
opts.plots.outputtype = 'pdf';

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% custom label color function
function c = CustomColorLib(L)
c = zeros(length(L),3); % initialize
for k = 1:length(L) % go through each label and assign a color
    switch upper(L{k})
        case 'LDR'
            ct = [244,67,54];
        case 'RDR'
            ct = [244,67,54]-10;
        case 'RDM'
            ct = [244,67,54]-20;
        case 'IMG'
            ct = [244,67,54]-30;
        case 'SND'
            ct = [244,67,54]-40;
        case 'GPS'
            ct = [244,67,54]-50;
        case 'GEO'
            ct = [139,195,74];
        case 'SUN'
            ct = [139,195,74]-20;
        case 'POL'
            ct = [139,195,74]-40;
    end
    c(k,:) = ct/255; % assign
end
end