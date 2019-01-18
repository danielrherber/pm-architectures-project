%--------------------------------------------------------------------------
% PMA_TreeSaveGraphs.m
% Save edge sets created by the tree algorithm
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [M,id] = PMA_TreeSaveGraphs(E,M,id,displevel)
    id = id + 1; % increment index of total graphs
    M(id,:) = E; % append current graph (a matching)
    if (displevel > 1) % verbose
        if (mod(id,10000) == 0)
            str = sprintf(',%c%c%c',fliplr(num2str(id)));
            str = fliplr(str(2:end));
            dispstat(['Graphs generated: ',str])
        end
    end
end