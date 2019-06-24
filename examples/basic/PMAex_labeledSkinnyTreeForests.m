%--------------------------------------------------------------------------
% PMAex_labeledSkinnyTreeForests.m
% Generate all labeled-rooted skinny-tree forests on n vertices
% OEIS A000262: 1, 3, 13, 73, 501, 4051, 37633, 394353, 4596553, ...
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
L = string(dec2base((1:n)+9,36));
C = vertcat('ROOT',L,'END');
R = [ones(n+1,1);n];
P = [n;repmat(2,n,1);1];
NSC.counts = 1; % no multiedges
NSC.M = ones(size(R)); % all components are mandatory

% options
opts.algorithm = 'tree_v11BFS';
opts.Nmax = 1e7; % maximum number of graphs to preallocate
opts.parallel = 0; % disable parallel computing
opts.filterflag = 0; % 1 is on, 0 is off
opts.plots.plotfun = 'matlab'; % 'circle' % 'bgl' % 'bio'
opts.plots.plotmax = 5;
opts.isomethod = 'none'; % turned off
opts.sortflag = 0;

% generate graphs
G1 = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% number of graphs based on OEIS A000262
n2 = 0;
for k = 1:n
   n2 = n2 + nchoosek(n,k)*nchoosek(n-1,k-1)*factorial(n-k);
end

% compare number of graphs
disp(isequal(length(G1),n2))