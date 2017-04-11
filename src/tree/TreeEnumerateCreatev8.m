%--------------------------------------------------------------------------
% TreeEnumerateCreatev8.m
% This includes all the relevant enhancements in the technical report
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [SavedGraphs,id] = TreeEnumerateCreatev8(V,E,SavedGraphs,id,A,B,iInitRep,cVf,Vf,Cflag,Nflag,Bflag,dispflag)
    
    % remove the first remaining port
    iL = find(V,1); % find nonzero entries (ports remaining)
    L = cVf(iL)-V(iL); % left port 
    V(iL) = V(iL)-1; % remove left port
    
    % START ENHANCEMENT: replicate ordering
    Vordering = uint8(circshift(V,1) ~= Vf); % check if left neighbor has been connected to something
    Vordering(iInitRep) = 1; % initial replicates are always 1
    % END ENHANCEMENT: replicate ordering
    
    % potential remaining ports
    Vallow = V.*Vordering.*A(iL,:);
    
    % find remaining nonzero entries
    I = find(Vallow);  
    
	% loop through all nonzero entries
    for iR = I
                
        % local for loop variables
        V2 = V; A2 = A;
        
        % remove another port creating an edge
        R = cVf(iR)-V2(iR); % right port
        E2 = [E,L,R]; % combine left, right ports for an edge
        V2(iR) = V2(iR)-1; % remove port (local copy)

        % START ENHANCEMENT: saturated subgraphs
        if Nflag
            iNonSat = find(V2); % find the nonsaturated components 
            if isequal(V2(iNonSat),Vf(iNonSat)) % check for saturated subgraph
                nUncon = sum(SavedGraphs(iNonSat));
                if (nUncon == 0) % define a one set of edges and stop
                    for j = 1:sum(V2) % add remaining edges in default order
                        k = find(V2,1); % find first nonzero entry
                        LR = cVf(k)-V2(k);
                        V2(k) = V2(k)-1; % remove port
                        E2 = [E2,LR]; % add port
                    end
                    [SavedGraphs,id] = TreeSaveGraphs(E2,SavedGraphs,id,dispflag);
                    continue
                elseif (nUncon == sum(SavedGraphs))
                    % continue iterating
                else
                    continue % stop, this graph is infeasible
                end     
            end
        end
        % END ENHANCEMENT: saturated subgraphs
               
        % START ENHANCEMENT: multi-edges
        if Cflag
            if (iR ~= iL) % don't do for self loops
                A2(iR,iL) = uint8(0); % limit this connection
                A2(iL,iR) = uint8(0); % limit this connection
            end
        end
        % END ENHANCEMENT: multi-edges
        
        % START ENHANCEMENT: line-connectivity constraints
        if Bflag
            A2(:,iR) = A2(:,iR).*B(:,iR,iL); % potentially limit connections 
            A2(:,iL) = A2(:,iL).*B(:,iL,iR); % potentially limit connections 
            A2([iR,iL],:) = A2(:,[iR,iL])'; % make symmetric
        end
        % END ENHANCEMENT: line-connectivity constraints
        
        if any(V2)
            [SavedGraphs,id] = TreeEnumerateCreatev8(V2,E2,SavedGraphs,id,A2,B,iInitRep,cVf,Vf,Cflag,Nflag,Bflag,dispflag);
        else
            if (length(E2) == cVf(end)-1)
                [SavedGraphs,id] = TreeSaveGraphs(E2,SavedGraphs,id,dispflag); continue
            end; continue
        end
        
    end % for iR = I
end