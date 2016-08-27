% this case study replicates the results from Case Study 1:
% http://systemdesign.illinois.edu/publications/Her16b.pdf
% FIGURE 10: All 16 unique graphs with no additional NSCs for Case Study 1.

clear
clc
close all
closeallbio

P = [1 2 3]'; % ports vector 
R = [3 2 1]'; % replicates vector
C = {'R','G','B'}; % label vector

% constraints
NCS.necessary = [0 0 0];
NCS.counts = 0;
NCS.self = 1; % allow self-loops
NCS.A = ones(length(P)); % provide potential adjacency matrix

% options
opts.algorithm = 'tree_v1';
opts.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.parallel = 0; % 0 to disable parallel computing, otherwise max number of workers
opts.IntPortTypeIsoFilter = 1; % 1 is on, 0 is off
% opts.customfun = @(pp,A,infeasibleFlag) ex_Example1_Extra_Constraints(pp,A,infeasibleFlag);
opts.plotfun = 'circle'; % 'circle' % 'bgl' % 'bio'
opts.plotmax = Inf; % maximum number of graphs to display/save
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to

% provide potential adjacency matrix
% A(1,1) = 0; % non R-R connections

UniqueUsefulGraphs;