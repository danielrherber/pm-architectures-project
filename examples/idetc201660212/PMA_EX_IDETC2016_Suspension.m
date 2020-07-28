%--------------------------------------------------------------------------
% PMA_EX_IDETC2016_Suspension.m
% This example replicates the results from Case Study 3 in the paper below
%--------------------------------------------------------------------------
% http://systemdesign.illinois.edu/publications/Her16b.pdf
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
NSC.self = 1; % allow self-loops
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
opts.parallel = true; % parallel computing, false to disable
opts.filterflag = 1; % 1 is on, 0 is off
NSC.userGraphNSC = @(pp,A,feasibleFlag) PMA_EX_IDETC2016_SuspensionConstraints(pp,A,feasibleFlag);
opts.isomethod = 'python'; % option 'Matlab' is available in 2016b or later versions

opts.plots.plotfun = 'bgl'; % 'circle' % 'bgl' % 'bio' % 'matlab'
opts.plots.plotmax = 20; % maximum number of graphs to display/save
opts.plots.name = mfilename; % name of the example
opts.plots.path = mfoldername(mfilename('fullpath'),[opts.plots.name,'_figs']); % path to save figures to
opts.plots.labelnumflag = 0; % add replicate numbers when plotting

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);