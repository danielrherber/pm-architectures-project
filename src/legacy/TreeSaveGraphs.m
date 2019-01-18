%--------------------------------------------------------------------------
% TreeSaveGraphs.m
% Save edge sets created by the tree algorithm
%--------------------------------------------------------------------------
% NOTE: purpose of this function is only to maintain compatibilty with a
% previous function name
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [M,id] = TreeSaveGraphs(E,M,id,displevel)

    [M,id] = PMA_TreeSaveGraphs(E,M,id,displevel);

end