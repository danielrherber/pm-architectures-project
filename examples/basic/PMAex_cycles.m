%--------------------------------------------------------------------------
% PMAex_cycles.m
% Generate all undirected labeled graphs on n nodes with exactly 1 cycle
% graph as a connected component
% OEIS A001710: 1, 1, 3, 12, 60, 360, 2520, 20160, 181440, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% number of vertices
n = 8;

% check n
validateattributes(n,{'numeric'},{'positive'})

% problem specification
C = [cellstr(strcat(dec2base((1:n)+9,36)))]; % labels
P = [repmat(2,n,1)]; % ports vector 
R.min = ones(n,1); R.max = R.min; % replicates vector
NSC.M = 1; % all components are mandatory
NSC.counts = 1; % all connections must be unique

% options
opts.algorithm = 'tree_v10';
opts.Nmax = 1e7; % maximum number of graphs to preallocate
opts.parallel = 0; % disable parallel computing
opts.filterflag = 1; % 1 is on, 0 is off
opts.plots.plotfun = 'matlab'; % 'circle' % 'bgl' % 'bio'
opts.plots.plotmax = 5;
opts.isomethod = 'none'; % turned off 

% generate graphs
G1 = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% number of graphs based on OEIS A001710
n2 = factorial(n-1)/2;

% compare number of graphs
disp(isequal(length(G1),n2))