%--------------------------------------------------------------------------
% TreeEnumerateCreatev1.m
% this is the algorithm in the DETC paper
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [SavedGraphs,id] = TreeEnumerateCreatev1(V,E,SavedGraphs,id,A,cVf,dispflag)

    % remove the first remaining port
    iL = find(V,1); % find nonzero entries (ports remaining)
    L = cVf(iL)-V(iL); % left port 
    V(iL) = V(iL)-1; % remove left port
    
    % potential remaining ports
    Vallow = V.*A(iL,:);
    
    % find remaining nonzero entries
    I = find(Vallow);  

	% loop through all nonzero entries
    for iR = I
        
        % local for loop variables
        V2 = V;
        
        % remove another port creating an edge
        R = cVf(iR)-V2(iR); % right port
        E2 = [E,L,R]; % combine left, right ports for an edge
        V2(iR) = V2(iR)-1; % remove port (local copy)
        
        if any(V2)
                [SavedGraphs,id] = TreeEnumerateCreatev1(V2,E2,SavedGraphs,id,A,cVf,dispflag);
        else
            if (length(E2) == cVf(end)-1)
                [SavedGraphs,id] = TreeSaveGraphs(E2,SavedGraphs,id,dispflag); continue
            end; continue
        end
        
    end % for iR = I
end