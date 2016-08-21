
% this is the algorithm in the DETC paper
function [M,id] = TreeEnumerateCreatev1(V,E,M,id,p)

    % remove the first remaining port
    I = find(V,1); % find nonzero entries
    L = p.pI(I)-V(I); % left port 
    V(I) = V(I)-1; % remove port
    
    % potential remaining ports
    AV = p.A(I,:).*V;
    
    % find remaining nonzero entries
    I = find(AV);

    for i = I % loop through all nonzero entries
        
        % local for loop variables
        Vo = V;
        
        % remove another port creating an edge
        R = p.pI(i)-Vo(i); % right port
        Eo = [E,L,R]; % combine left and right ports for an edge
        Vo(i) = Vo(i)-1; % remove port (local copy)
        
        if any(Vo)
                [M,id] = TreeEnumerateCreatev1(Vo,Eo,M,id,p);
        else
            if (length(Eo) == p.pI(end)-1)
                id = id+1; % increment index of total graphs
                M(id,:) = Eo; % append current graph (a matching)
                if mod(id,10000) == 0
                      moneyString = sprintf(',%c%c%c',fliplr(num2str(id)));
                    moneyString = fliplr(moneyString(2:end));
                   dispstat(['Graphs generated: ',moneyString])
                end; return
            end; return
        end
    end