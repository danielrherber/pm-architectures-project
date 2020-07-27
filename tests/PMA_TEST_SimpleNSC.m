%--------------------------------------------------------------------------
% PMA_TEST_SimpleNSC.m
% Test for NSC.simple
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

testnum = 4;

switch testnum
    %----------------------------------------------------------------------
    case 1 % just B (6 graphs)
    NSC.simple = [0,0,1];
    %----------------------------------------------------------------------
    case 2 % just G and R (6 graphs)
    NSC.simple = [1,1,0];
    %----------------------------------------------------------------------
    case 3 % all (3 graphs)
    NSC.simple = 1;
    %----------------------------------------------------------------------
    case 4 % none (16 graphs)
    NSC.simple = 0;
    %----------------------------------------------------------------------
end

% problem specification
C = {'R','G','B'};
R = [3,2,1];
P = [1,2,3];

% options
opts = [];
opts.algorithm = 'tree_v8';

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);