%--------------------------------------------------------------------------
% PMA_TEST_LineConnectivityNSC.m
% Test for NSC.lineTriple
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

testnum = 1;

switch testnum
    %----------------------------------------------------------------------
    case 1 % R-G\B
    NSC.lineTriple(1,:) = [1,2,3];
    %----------------------------------------------------------------------
    case 2 % G-G\B and
    NSC.lineTriple(1,:) = [1,2,3];
    NSC.lineTriple(2,:) = [2,2,3];
    %----------------------------------------------------------------------
    case 3 % no constraints
    NSC = [];
    %----------------------------------------------------------------------
end

% problem specification
C = {'R','G','B'};
R = [3,2,1];
P = [1,2,3];

% options
opts = [];
opts.algorithm = 'tree_v1';

FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);