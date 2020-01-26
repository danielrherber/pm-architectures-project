%--------------------------------------------------------------------------
% Test_Treev1mex.m.m
% test for tree_v1_mex option
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

P = [1 1 1 2 2 2 3 4]; % ports vector
R.min = [1 1 0 2 2 1 2 0]; % replicate vector
R.max = [1 1 0 2 2 1 2 0]; % replicate vector
C = {'s','u','m', 'k', 'b', 'f', 'p', 'p'}; % label vector

% constraints
NSC.simple = 1;
NSC.connected = 1;

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
% opts.algorithm = 'tree_v1';
opts.algorithm = 'tree_v1_mex';

opts.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.customfun = @(pp,A,feasibleFlag) PMAex_md161635_suspensionConstraints(pp,A,feasibleFlag);
opts.plotmax = 0; % maximum number of graphs to display/save
opts.isomethod = 'None';
opts.parallel = 0;

FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);