%--------------------------------------------------------------------------
% PMA_EnumerationAlg_v8_analysis.m
% This includes all the relevant enhancements in the technical report
% (analysis version)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [SavedGraphs,id] = PMA_EnumerationAlg_v8_analysis(V,E,SavedGraphs,id,...
    cVf,Vf,iInitRep,counts,A,Bflag,B,Mflag,M,displevel,prenode)

option = 1; PMA_TreeAnalysis; %#ok<NASGU>

% remove the first remaining port
iL = find(V,1); % find nonzero entries (ports remaining)
L = cVf(iL)-V(iL); % left port
V(iL) = V(iL)-1; % remove left port

% START ENHANCEMENT: replicate ordering
Vordering = uint8(circshift(V,[0,1]) ~= Vf); % check if left neighbor has been connected to something
Vordering(iInitRep) = 1; % initial replicates are always 1
% END ENHANCEMENT: replicate ordering

% potential remaining ports
Vallow = V.*Vordering.*A(iL,:);

% find remaining nonzero entries
I = find(V); % modification for analysis function

% loop through all nonzero entries
for iR = I

    option = 2; PMA_TreeAnalysis; %#ok<NASGU>
    if continueflag; continue; end

    % local for loop variables
    V2 = V; A2 = A;

    % remove another port creating an edge
    R = cVf(iR)-V2(iR); % right port
    E2 = [E,L,R]; % combine left, right ports for an edge
    V2(iR) = V2(iR)-1; % remove port (local copy)

    % START ENHANCEMENT: saturated subgraphs
    if Mflag
        iNonSat = find(V2(:)); % find the nonsaturated components
        if isequal(V2(iNonSat),Vf(iNonSat)) % check for saturated subgraph
            nUncon = sum(M(iNonSat));
            if (nUncon == 0) % define a one set of edges and stop
                for j = 1:sum(V2) % add remaining edges in default order
                    k = find(V2,1); % find first nonzero entry
                    LR = cVf(k)-V2(k);
                    V2(k) = V2(k)-1; % remove port
                    E2 = [E2,LR]; % add port
                end
                [SavedGraphs,id] = TreeSaveGraphs(E2,SavedGraphs,id,displevel);
                continue
            elseif (nUncon == sum(M))
                % continue iterating
            else
                option = 3; PMA_TreeAnalysis; %#ok<NASGU>
                continue % stop, this graph is infeasible
            end
        end
    end
    % END ENHANCEMENT: saturated subgraphs

    % START ENHANCEMENT: multi-edges
    if counts(iL) || counts(iR) % if either component needs unique connections
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

    if any(V2) % recursive call if any remaining vertices
        [SavedGraphs,id] = PMA_EnumerationAlg_v8_analysis(V2,E2,SavedGraphs,id,cVf,Vf,iInitRep,counts,A2,Bflag,B,Mflag,M,displevel,node);
    else % save the complete perfect matching graph
        [SavedGraphs,id] = TreeSaveGraphs(E2,SavedGraphs,id,displevel);
    end

end % for iR = I

end % function PMA_EnumerationAlg_v8_analysis