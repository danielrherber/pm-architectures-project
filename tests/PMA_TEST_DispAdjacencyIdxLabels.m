%--------------------------------------------------------------------------
% PMA_TEST_DispAdjacencyIdxLabels.m
% test for DispAdjacencyIdxLabels
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

AdjType = DispAdjacencyIdxLabels(C,P,S);

%
C = {'R','G','B','O'};
R = [3,2,1,2];
P = [1,2,5,3];
S = [1,1,1,1];

AdjType = DispAdjacencyIdxLabels(C,P,S);

%
C = {'R','G','B','O'};
R = [3,2,1,2];
P = [1,2,5,3];
S = [0,0,0,0];

AdjType = DispAdjacencyIdxLabels(C,P,S);