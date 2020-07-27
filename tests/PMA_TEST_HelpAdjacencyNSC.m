%--------------------------------------------------------------------------
% PMA_TEST_HelpAdjacencyNSC.m
% Test for PMA_HelpAdjacencyNSC
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test 1
C = {'R','G','B','O'};
R = [3,2,1,2];
P = [1,2,5,3];
S = [1,0,1,0];

ConstraintMatrix = PMA_STRUCT_HelpAdjacencyNSC(C,P,S);