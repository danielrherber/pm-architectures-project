%--------------------------------------------------------------------------
% PMA_TEST_LineConnectivityNSC.m
% test for NSC.Bind
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

testnum = 1;

switch testnum
    case 1 % R-G\B
        NSC.Bind(1,:) = [1,2,3];
    case 2 % G-G\B and 
        NSC.Bind(1,:) = [1,2,3];
        NSC.Bind(2,:) = [2,2,3];
    case 3 % no constraints
        NSC = [];
end

C = {'R','G','B'};
R = [3,2,1];
P = [1,2,3];

opts = [];
opts.algorithm = 'tree_v1';

FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);