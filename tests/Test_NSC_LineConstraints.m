%--------------------------------------------------------------------------
% Test_NSC_LineConstraints.m
% test for NSC.Bind
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
close all
clear
clc

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

FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);