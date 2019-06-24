%--------------------------------------------------------------------------
% PMAex_perfectMatchings.m
% Generate a list of all the perfect matchings of a complete graph
% OEIS A001147: 1, 3, 15, 105, 945, 10395, 135135, 2027025, ...
% Also compared to MFX 52301 for the same task (noting that this code 
% is slower because more general enumeration tasks can be performed)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% number of vertices
n = 14;

% check n
validateattributes(n,{'numeric'},{'positive','even'})

% problem specification
C = cellstr(strcat(dec2base((1:n)+9,36))); % labels
P = ones(n,1); % ports vector 
R = ones(n,1); % replicates vector
NSC = []; % no constraints

% options
opts.algorithm = 'tree_v11DFS_mex';
opts.Nmax = 1e7; % maximum number of graphs to preallocate
opts.parallel = 0; % 0 to disable parallel computing
opts.filterflag = 0; % 1 is on, 0 is off
opts.plots.plotmax = 5;
opts.isomethod = 'none'; % turned off 

% generate graphs
G1 = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% compare to MFX 52301
tic
G2 = PM_perfectMatchings(n);
toc

% compare number of graphs
disp(isequal(length(G1),size(G2,1)))