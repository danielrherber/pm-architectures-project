%--------------------------------------------------------------------------
% PMA_TEST_HelpAdjacencyNSC.m
% test for PMA_HelpAdjacencyNSC
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

C = {'R','G','B','O'};
R = [3,2,1,2];
P = [1,2,5,3];
S = [1,0,1,0];

ConstraintMatrix = HelpAdjacencyNSC(C,P,S);