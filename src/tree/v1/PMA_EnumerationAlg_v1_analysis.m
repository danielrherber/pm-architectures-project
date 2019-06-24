%--------------------------------------------------------------------------
% PMA_EnumerationAlg_v1_analysis.m
% This is the algorithm in the DETC paper (analysis version)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [SavedGraphs,id] = PMA_EnumerationAlg_v1_analysis(V,E,SavedGraphs,id,cVf,A,displevel,prenode)

    global node nodelist labellist

    % remove the first remaining port
    iL = find(V,1); % find nonzero entries (ports remaining)
    L = cVf(iL)-V(iL); % left port 
    V(iL) = V(iL)-1; % remove left port

    % zero infeasible edges
    Vallow = V.*A(iL,:);

    % find remaining nonzero entries
    % I = find(Vallow);
    I = find(V); % modification for analysis function

	% loop through all nonzero entries
	for iR = I

        nodelist = [nodelist,prenode];
        labellist = [labellist,[iL;iR]];
        node = node + 1;
        
        if V(iR)~=Vallow(iR) % modification for analysis function
           continue 
        end

        V2 = V; % local for loop variables
        R = cVf(iR)-V2(iR); % right port
        E2 = [E,L,R]; % combine left, right ports for an edge
        V2(iR) = V2(iR)-1; % remove port (local copy)
        
        if any(V2) % recursive call if any remaining vertices
            [SavedGraphs,id] = PMA_EnumerationAlg_v1_analysis(V2,E2,SavedGraphs,id,cVf,A,displevel,node);
        else % save the complete perfect matching graph
            [SavedGraphs,id] = TreeSaveGraphs(E2,SavedGraphs,id,displevel);
        end

	end % for iR = I

end % function PMA_EnumerationAlg_v1_analysis