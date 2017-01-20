%--------------------------------------------------------------------------
% HelpAdjacencyNSC.m
% test for HelpAdjacencyNSC
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
C = {'R','G','B','O'};
R = [3,2,1,2];
P = [1,2,5,3];
S = [1,0,1,0];

ConstraintMatrix = HelpAdjacencyNSC(C,P,S);