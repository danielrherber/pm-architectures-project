%--------------------------------------------------------------------------
% PMA_EX_Permuting.m
% The permuting pattern seeks to arrange a set of elements in different
% orderings
%--------------------------------------------------------------------------
% D. Selva, B. Cameron, and E. Crawley, "Patterns in System Architecture
% Decisions," Syst Eng, vol. 19, no. 6, pp. 477–497, Nov. 2016, doi:
% 10.1002/sys.21370
% D. R. Herber, "Enhancements to the perfect matching approach for graph
% enumeration-based engineering challenges. In ASME 2020 International
% Design Engineering Technical Conferences, DETC2020-22774, Aug. 2020.
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 5; % number of nodes

% problem specification
L = ['STR';string(dec2base((1:n)+9,36))]; % labels
R.min = ones(n+1,1); R.max = R.min; % replicate vector
P.min = ones(n+1,1); P.max = [1;repmat(2,n,1)]; % ports vector

% network structure constraints
NSC.simple = 1; % simple components
NSC.connected = 1; % connected graph required
NSC.loops = 0; % no loops

% options
opts.algorithm = 'tree_v12BFS_mex';
opts.algorithms.Nmax = 1e6;
opts.isomethod = 'none'; % not needed
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

% obtain all unique, feasible graphs
[G,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);