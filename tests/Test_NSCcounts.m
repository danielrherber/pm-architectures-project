%--------------------------------------------------------------------------
% Test_NSCcounts.m
% test for NSC.counts (newer implementation)
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
    case 1 % just B
        NSC.counts = [0,0,1];
    case 2 % just G and R
        NSC.counts = [1,1,0];
    case 3 % all 
        NSC.counts = 1;
    case 4 % none 
        NSC.counts = 0;
end

C = {'R','G','B'};
R = [3,2,1];
P = [1,2,3];

opts = [];
opts.algorithm = 'tree_v8';

FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);