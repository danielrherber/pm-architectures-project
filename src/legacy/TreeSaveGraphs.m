%--------------------------------------------------------------------------
% TreeSaveGraphs.m
% Save edge sets created by the tree algorithm
%--------------------------------------------------------------------------
% NOTE: purpose of this function is only to maintain compatibility with a
% previous function name
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [M,id] = TreeSaveGraphs(E,M,id,displevel)

% call new function
[M,id] = PMA_TreeSaveGraphs(E,M,id,displevel);

end