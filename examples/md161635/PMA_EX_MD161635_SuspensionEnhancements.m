%--------------------------------------------------------------------------
% PMA_EX_MD161635_SuspensionEnhancements.m
% Replicates the results from Case Study 3 in the paper below
% Uses the enhancements in the technical report
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017; 139(5):051403. doi:10.1115/1.4036132
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% problem specification
P = [1 1 1 2 2 2 3 4]; % ports vector
R.min = [1 1 0 0 0 0 0 0]; % replicate vector
R.max = [1 1 2 2 2 1 2 2]; % replicate vector
C = {'s','u','m', 'k', 'b', 'f', 'p', 'p'}; % label vector

% constraints
% NSC.M = [1 1 0 0 0 0 0 0]; % mandatory components
NSC.simple = 1;
NSC.connected = 1;
NSC.loops = 0;

% potential adjacency matrix
A = ones(length(P)); % initialize
A(2,1) = 0; % u-s
A(3,1) = 0; % m-s
A(3,2) = 0; % m-u
A(4,4) = 0; % k-k
A(5,5) = 0; % b-b
A(7,7) = 0; % p-p
A(8,7) = 0; % p-p
A(8,8) = 0; % p-p
NSC.directA = A;

% line-connectivity constraints
NSC.lineTriple(1,:) = [1,7,2]; % s-p-u
NSC.lineTriple(2,:) = [2,7,1]; % u-p-s
NSC.lineTriple(3,:) = [1,8,2]; % s-p-u
NSC.lineTriple(4,:) = [2,8,1]; % u-p-s

% custom graph NSC function
NSC.userGraphNSC = @(pp,A,feasibleFlag) PMA_EX_MD161635_SuspensionConstraints(pp,A,feasibleFlag);

% options
opts.algorithm = 'tree_v12BFS_mex';
opts.Nmax = 1e6; % maximum number of graphs to preallocate for
opts.parallel = true; % 12 threads for parallel computing, 0 to disable it
opts.filterflag = 1; % 1 is on, 0 is off
opts.isomethod = 'python'; % option 'matlab' is available in 2016b or later versions
opts.plots.plotfun = 'bgl'; % 'circle' % 'bgl' % 'bio' % 'matlab'
opts.plots.plotmax = 0; % maximum number of graphs to display/save
opts.plots.name = mfilename; % name of the example
opts.plots.path = mfoldername(mfilename('fullpath'),[opts.plots.name,'_figs']); % path to save figures to
opts.plots.labelnumflag = 0; % add replicate numbers when plotting

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);