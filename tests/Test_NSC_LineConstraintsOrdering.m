%--------------------------------------------------------------------------
% Test_NSC_LineConstraintsOrdering.m
% test line-connectivity constraints when (C,R,P) is reordered
%--------------------------------------------------------------------------
% NOTE: this test function was used to fix a bug where NSC.Bind was not
% sorted properly in PMA_ReorderCRP.m
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
close all; clear; clc

% test options
testnum = 3;
N = 3; % number of B replicates
sortflag = 1; % 1:on, 0:off

switch testnum
    case 1 % A-B\C
        NSC.Bind(1,:) = [1,2,3];
    case 2 % A-B\C and B-C\A
        NSC.Bind(1,:) = [1,2,3];
        NSC.Bind(2,:) = [2,3,1];
    otherwise % no constraints
        NSC = [];
end

% problem specification
C = {'A','B','C','D'};
R = [1,N,2,1];
P = [2,2,4,2];
NSC.counts = 1;

% options
opts = [];
opts.algorithm = 'tree_v1'; % 'tree_v2'
opts.sortflag = sortflag;
opts.isomethod = 'python'; % need an isomorphism checking method to compare
opts.plots.plotmax = 0;

% generate the unique useful graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);