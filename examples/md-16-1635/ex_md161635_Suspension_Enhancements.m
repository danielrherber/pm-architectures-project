%--------------------------------------------------------------------------
% ex_md161635_Suspension_Enhancements.m
% Replicates the results from Case Study 3 in JMD paper MD-16-1635
% Uses the enhancements in the technical report
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear
clc
close all
closeallbio

P = [1 1 1 2 2 2 3 4]; % ports vector 
R.min = [1 1 0 0 0 0 0 0]; % replicate vector 
R.max = [1 1 2 2 2 1 2 2]; % replicate vector 
C = {'s','u','m', 'k', 'b', 'f', 'p', 'p'}; % label vector 

% constraints
NSC.M = [1 1 0 0 0 0 0 0]; % mandatory components
NSC.counts = 1;

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
NSC.A = A;

% line-connectivity constraints
NSC.Bind(1,:) = [1,7,2]; % s-p-u
NSC.Bind(2,:) = [2,7,1]; % u-p-s
NSC.Bind(3,:) = [1,8,2]; % s-p-u
NSC.Bind(4,:) = [2,8,1]; % u-p-s

% options
opts.algorithm = 'tree_v8_mex';
opts.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.parallel = 12; % 1 to enable parallel computing, 0 to disable it
opts.filterflag = 1; % 1 is on, 0 is off
opts.customfun = @(pp,A,infeasibleFlag) ex_md161635_Suspension_Extra_Constraints(pp,A,infeasibleFlag);
opts.plotfun = 'bgl'; % 'circle' % 'bgl' % 'bio'
opts.plotmax = 0; % maximum number of graphs to display/save
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to
opts.isomethod = 'Python'; % option 'Matlab' is available in 2016b or later versions

FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);