%--------------------------------------------------------------------------
% PMA_EX_MD161635_Suspension.m
% This example replicates the results from Case Study 3 in the paper below
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017; 139(5):051403. doi:10.1115/1.4036132
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% problem specification
P = [1 1 1 2 2 2 3 4]'; % ports vector
R = [1 1 2 2 2 1 2 2]'; % replicate vector
C = {'s','u','m', 'k', 'b', 'f', 'p', 'p'}; % label vector

% constraints
NSC.M = [1 1 0 0 0 0 0 0];
NSC.simple = 1;
NSC.connected = 1;
% NSC.self = 1; % allow self-loops
% provide potential adjacency matrix
A = ones(length(P));
A(2,1) = 0;
A(3,1) = 0;
A(3,2) = 0;
A(4,4) = 0;
A(5,5) = 0;
A(7,7) = 0;
A(8,7) = 0;
A(8,8) = 0;
A = round((A+A')/3);
NSC.directA = A;

% options
opts.algorithm = 'tree_v1';
opts.Nmax = 2e8; % maximum number of graphs to preallocate for
opts.parallel = true; % parallel computing, false to disable it
opts.filterflag = 1; % 1 is on, 0 is off
NSC.userGraphNSC = @(pp,A,feasibleFlag) PMA_EX_MD161635_SuspensionConstraints(pp,A,feasibleFlag);
opts.plotfun = 'bgl'; % 'circle' % 'bgl' % 'bio'
opts.plotmax = 0; % maximum number of graphs to display/save
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to
opts.isomethod = 'python'; % option 'matlab' is available in 2016b or later versions

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);