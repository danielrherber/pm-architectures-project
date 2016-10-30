function [M,id] = TreeSaveGraphs(E,M,id)
    id = id+1; % increment index of total graphs
    M(id,:) = E; % append current graph (a matching)
    if mod(id,10000) == 0
        moneyString = sprintf(',%c%c%c',fliplr(num2str(id)));
        moneyString = fliplr(moneyString(2:end));
        dispstat(['Graphs generated: ',moneyString])
    end
end