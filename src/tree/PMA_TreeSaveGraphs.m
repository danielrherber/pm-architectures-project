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

% increment index of total graphs
id = id + 1;

% check if we need more storage
if id > size(M,1)

    % double size
    M = vertcat(M,zeros(size(M),'uint8'));

end

% append current graph (a matching)
M(id,:) = E;

% potentially display to command window
if (displevel > 1)
    if (mod(id,uint64(10000)) == 0) || (id == 1) % only every 10000 graphs

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