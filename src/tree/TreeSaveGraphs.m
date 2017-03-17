function [M,id] = TreeSaveGraphs(E,M,id,displevel)
    id = id + 1; % increment index of total graphs
    M(id,:) = E; % append current graph (a matching)
    if displevel
        if (mod(id,10000) == 0)
            str = sprintf(',%c%c%c',fliplr(num2str(id)));
            str = fliplr(str(2:end));
            dispstat(['Graphs generated: ',str])
        end
    end
end