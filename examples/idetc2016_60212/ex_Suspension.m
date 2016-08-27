% this case study replicates the results from Case Study 3:
% http://systemdesign.illinois.edu/publications/Her16b.pdf

clear
clc
close all
closeallbio

P = [1 1 1 2 2 2 3 4]'; % ports vector 
R = [1 1 2 2 2 1 2 2]'; % replicate vector 
C = {'s','u','m', 'k', 'b', 'f', 'p', 'p'}; % label vector 

% constraints
NCS.necessary = [1 1 0 0 0 0 0 0];
NCS.counts = 1;
NCS.self = 1; % allow self-loops
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
NCS.A = A;

% options
opts.algorithm = 'tree_v3'; % 'tree_v3' % 'pm_full' % 'pm_incomplete'
opts.Nmax = 1e8; % maximum number of graphs to preallocate for
opts.parallel = 1; % 1 to enable parallel computing, 0 to disable it
opts.IntPortTypeIsoFilter = 1; % 1 is on, 0 is off
opts.customfun = @(pp,A,infeasibleFlag) ex_Suspension_Extra_Constraints(pp,A,infeasibleFlag);
opts.plotfun = 'bio'; % 'circle' % 'bgl' % 'bio'
opts.plotmax = 0; % maximum number of graphs to display/save
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to

tic
UniqueUsefulGraphs;
toc