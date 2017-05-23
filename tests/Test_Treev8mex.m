%--------------------------------------------------------------------------
% Test_Treev8mex.m
% test for tree_v8_mex option
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
close all
clear
clc

P = [1 1 1 2 2 2 3 4]; % ports vector 
R.min = [1 1 2 2 2 1 2 1]; % replicate vector 
R.max = [1 1 2 2 2 1 2 1]; % replicate vector 
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
opts.algorithm = 'tree_v8';
% opts.algorithm = 'tree_v8_mex';

opts.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.customfun = @(pp,A,infeasibleFlag) ex_md161635_Suspension_Extra_Constraints(pp,A,infeasibleFlag);
opts.plotmax = 0; % maximum number of graphs to display/save
opts.isomethod = 'None';
opts.parallel = 0;

FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);