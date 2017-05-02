%--------------------------------------------------------------------------
% TreeExploreCreate1.m
% Using the tree_v1 algorithm, generate a single graph using randomly
% selected feasible edges
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [M,id] = TreeExploreCreate1(V,E,M,cp,id,A)
    N = sum(V ~= 0);
    if N > 1 % if multiple nonzero elements
        I = find(V); % find nonzero entries
        L = cp(I(1))-V(I(1)); % left port 
        V(I(1)) = V(I(1))-1; % remove port        
        AV = A(I(1),:).*V;
        I = find(AV); % find remaining nonzero entries

        if isempty(I)
            return
        end
        i = I(randi(length(I))); % random entry
        Vo = V; Eo = E; % local for loop variables
        R = cp(i)-V(i); % right port
        Eo = [Eo,L,R]; % combine left and right ports for an edge
        Vo(i) = Vo(i)-1; % remove port (local copy)
        if any(Vo)
            [M,id] = TreeExploreCreate1(Vo,Eo,M,cp,id,A);
        else
            id = id+1; % increment index of total graphs
            M(id,:) = Eo; % append current graph (a matching)
        end
            
    elseif N == 1 % exactly one nonzero element
        % create self loops
        while any(V)
            I = find(V); % find nonzero entries
            L = cp(I)-V(I); % left port 
            V(I) = V(I)-1; % remove port
            AV = A(I,:).*V;
            I = find(AV); % find remaining nonzero entries
            R = cp(I)-V(I); % right port
            E = [E,L,R]; % combine left and right ports for an edge
            V(I) = V(I)-1; % remove port (local copy)
        end
        id = id+1; % increment index of total graphs
        M(id,:) = E; % append current graph (a matching)  
    end
    
end