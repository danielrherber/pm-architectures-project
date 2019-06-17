%--------------------------------------------------------------------------
% PMAex_trivalentConnectedGraphs.m
% Generate all unlabeled trivalent connected graphs with 2n vertices 
% OEIS A002851: 0, 1, 2, 5, 19, 85, 509, 4060, 41301, 510489, 7319447, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% number of vertices
n = 12; % practical up to n = 14

% check n
validateattributes(n,{'numeric'},{'positive','even'})

% problem specification
C = {'L'}; % labels
P = 3; % ports vector 
R = n; % replicates vector
NSC.M = ones(size(C));
NSC.counts = 1;

% options
opts.algorithm = 'tree_v10';
opts.Nmax = 1e7; % maximum number of graphs to preallocate
opts.parallel = 0; % 0 to disable parallel computing
opts.filterflag = 1; % 1 is on, 0 is off
opts.plots.plotmax = 25;
opts.isomethod = 'python';

% generate graphs
G1 = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% compare to OEIS A002851
N = [0,1,2,5,19,85,509,4060,41301,510489,7319447];
n2 = N(n/2);

% compare number of graphs
disp(isequal(length(G1),n2))