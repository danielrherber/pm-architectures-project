%--------------------------------------------------------------------------
% PMA_TreeSaveGraphs.m
% Save edge sets created by the tree algorithm
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [M,id] = PMA_TreeSaveGraphs(E,M,id,displevel)
    id = id + 1; % increment index of total graphs
    M(id,:) = E; % append current graph (a matching)
    if id == size(M,1) % check if we need more storage
        M = vertcat(M,zeros(size(M),'uint8')); % double size
    end
    if (displevel > 1) % verbose
        if (mod(id,uint64(10000)) == 0) || (id == 1)
            % check if this is the first graph generated
            if id == 1
                % initial string
                fprintf('Graphs generated: ');
            else
                % remove previous
                fprintf(repmat('\b', 1, 11));
            end
            % current number of graphs (fixed size)
            fprintf('%10d',int64(id));
            % new line
            fprintf('\n');
        end
    end
end