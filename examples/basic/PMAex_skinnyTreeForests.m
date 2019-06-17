%--------------------------------------------------------------------------
% PMAex_skinnyTreeForests.m
% Generate all unlabeled-rooted skinny-tree forests on n vertices
% OEIS A000041: 1, 2, 3, 5, 7, 11, 15, 22, 30, 42, 56, 77, 101, 135, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% number of vertices
n = 8; % practical up to n = 11

% check n
validateattributes(n,{'numeric'},{'positive'})

% problem specification
C = {'R','L','E'};
R = [1;n;n];
P = [n;2;1];
NSC.counts = 1; % no multiedges
NSC.M = ones(size(R)); % all components are mandatory

% options
opts.algorithm = 'tree_v10';
opts.Nmax = 1e5; % maximum number of graphs to preallocate
opts.parallel = 0; % disable parallel computing
opts.filterflag = 1; % 1 is on, 0 is off
opts.plots.plotfun = 'matlab'; % 'circle' % 'bgl' % 'bio'
opts.plots.plotmax = 10;
opts.isomethod = 'python';
opts.sortflag = 0;

% generate graphs
G1 = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% number of graphs based on OEIS A000262
N = [1,2,3,5,7,11,15,22,30,42,56,77,101,135,176,231,297,385,490,627,792];
n2 = N(n);

% compare number of graphs
disp(isequal(length(G1),n2))