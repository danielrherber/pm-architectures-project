%--------------------------------------------------------------------------
% PMA_EnumerationAlg_v1.m
% This is the algorithm in the DETC paper
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [SavedGraphs,id] = PMA_EnumerationAlg_v1(V,E,SavedGraphs,id,cVf,A,displevel)

% remove the first remaining port
iL = find(V,1); % find nonzero entries (ports remaining)
L = cVf(iL)-V(iL); % left port
V(iL) = V(iL)-1; % remove left port

% zero infeasible edges
Vallow = V.*A(iL,:);

% find remaining nonzero entries
I = find(Vallow(:));

% loop through all nonzero entries
for iRidx = 1:length(I)

    iR = I(iRidx); % extract

    V2 = V; % local for loop variables
    R = cVf(iR)-V2(iR); % right port
    E2 = [E,L,R]; % combine left, right ports for an edge
    V2(iR) = V2(iR)-1; % remove port (local copy)

    if any(V2) % recursive call if any remaining vertices
        [SavedGraphs,id] = PMA_EnumerationAlg_v1(V2,E2,SavedGraphs,id,cVf,A,displevel);
    else % save the complete perfect matching graph
        [SavedGraphs,id] = PMA_TreeSaveGraphs(E2,SavedGraphs,id,displevel);
    end

end % for iRidx = 1:length(I)

end % function PMA_EnumerationAlg_v1