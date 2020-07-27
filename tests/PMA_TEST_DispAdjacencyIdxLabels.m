%--------------------------------------------------------------------------
% PMA_TEST_DispAdjacencyIdxLabels.m
% Test for PMA_STRUCT_DispAdjacencyIdxLabels
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

AdjType = PMA_STRUCT_DispAdjacencyIdxLabels(C,P,S);

% test 2
C = {'R','G','B','O'};
R = [3,2,1,2];
P = [1,2,5,3];
S = [1,1,1,1];

AdjType = PMA_STRUCT_DispAdjacencyIdxLabels(C,P,S);

% test 3
C = {'R','G','B','O'};
R = [3,2,1,2];
P = [1,2,5,3];
S = [0,0,0,0];

AdjType = PMA_STRUCT_DispAdjacencyIdxLabels(C,P,S);