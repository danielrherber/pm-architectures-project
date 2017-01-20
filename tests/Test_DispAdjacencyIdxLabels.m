%--------------------------------------------------------------------------
% Test_DispAdjacencyIdxLabels.m
% test for DispAdjacencyIdxLabels 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
% 
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