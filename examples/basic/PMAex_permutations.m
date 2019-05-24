%--------------------------------------------------------------------------
% PMAex_permutations.m
% Generate all permutations of n vertices
% OEIS A000142: 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, ...
% Also compared to builtin function for the same task (noting that this
% code is slower because more general enumeration tasks can be performed)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% number of vertices
n = 6;

% check n
validateattributes(n,{'numeric'},{'positive'})

% problem specification
C = ['STR';'END';cellstr(strcat(dec2base((1:n)+9,36)))]; % labels
P = [1;1;repmat(2,n,1)]; % ports vector 
R.min = ones(n+2,1); R.max = R.min; % replicates vector
NSC.M = 1; % all components are mandatory
NSC.counts = 1; % all connections must be unique

% options
opts.algorithm = 'tree_v8_mex';
opts.Nmax = 1e7; % maximum number of graphs to preallocate
opts.parallel = 0; % 0 to disable parallel computing
opts.filterflag = 1; % 1 is on, 0 is off
opts.plots.plotfun = 'matlab'; % 'circle' % 'bgl' % 'bio'
opts.plots.plotmax = 5;
opts.isomethod = 'none'; % turned off 

% generate graphs
G1 = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% compare to builtin function
tic
G2 = perms(1:n);
toc

% compare number of graphs
disp(isequal(length(G1),size(G2,1)))