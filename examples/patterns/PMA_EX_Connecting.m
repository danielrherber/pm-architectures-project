%--------------------------------------------------------------------------
% PMA_EX_Connecting.m
% The Connecting Pattern emphasizes the connectivity between a
% predetermined set of entities. Given a set of entities, seen as the
% vertices of a graph, an architecture fragment in the connecting pattern
% is given by a set of edges connecting those vertices
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

NL = 6; % number of labels
L = cellstr(string(dec2base((1:NL)+9,36)))'; % labels
R.min = ones(NL,1); R.max = R.min; % replicates
P.min = zeros(NL,1); P.max = repelem(NL,NL,1); % ports

% network structure constraints
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops

% options
opts.plots.plotmax = 1;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;
opts.algorithm = 'tree_v12BFS_mex';
opts.isomethod = 'none'; % no needed for the partitioning problem
opts.parallel = true;
opts.algorithms.Nmax = 1e5;
opts.plots.saveflag = false;
opts.plots.outputtype = 'pdf';

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);