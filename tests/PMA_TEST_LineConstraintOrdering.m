%--------------------------------------------------------------------------
% PMA_TEST_LineConstraintOrdering.m
% Test line-connectivity constraints when (C,R,P) is reordered
%--------------------------------------------------------------------------
% NOTE: this test function was used to fix a bug where NSC.lineTriple was not
% sorted properly in PMA_ReorderCRP.m
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test options
testnum = 0;
sortflag = 0; % 1:on, 0:off
N = 2; % number of B replicates

switch testnum
    %----------------------------------------------------------------------
    case 1 % A-B\C
    NSC.lineTriple(1,:) = [1,2,3];
    %----------------------------------------------------------------------
    case 2 % A-B\C and B-C\A
    NSC.lineTriple(1,:) = [1,2,3];
    NSC.lineTriple(2,:) = [2,3,1];
    %----------------------------------------------------------------------
    otherwise % no constraints
    NSC = [];
    %----------------------------------------------------------------------
end

% problem specification
C = {'A','B','C','D'};
R = [1,N,2,1];
P = [2,2,4,2];
NSC.simple = 1;
NSC.connected = 1;
NSC.loops = 0;

% options
opts = [];
opts.algorithm = 'tree_v11BFS';
opts.sortflag = sortflag;
opts.isomethod = 'python'; % need an isomorphism checking method to compare
opts.plots.plotmax = 10;

% generate the unique useful graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);