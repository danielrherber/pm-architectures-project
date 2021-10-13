%--------------------------------------------------------------------------
% PMA_StochasticAlg_v1.m
% Using the tree_v1 algorithm, generate a single graph using randomly
% selected feasible edges
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [SavedGraphs,id] = PMA_StochasticAlg_v1(V,E,SavedGraphs,id,A,cVf,dispflag)

% remove the first remaining port
iL = find(V,1); % find nonzero entries (ports remaining)
L = cVf(iL)-V(iL); % left port
V(iL) = V(iL)-1; % remove left port

% zero infeasible edges
Vallow = V.*A(iL,:);

% find remaining nonzero entries
I = find(Vallow(:));

% randomly select an available edge
if isempty(I)
    return
else
    iR = I(randi(length(I))); % equal probabilities for each edge
end

V2 = V; % local for loop variables
R = cVf(iR)-V2(iR); % right port
E2 = [E,L,R]; % combine left, right ports for an edge
V2(iR) = V2(iR)-1; % remove port (local copy)

if any(V2) % recursive call if any remaining vertices
    [SavedGraphs,id] = PMA_StochasticAlg_v1(V2,E2,SavedGraphs,id,A,cVf,dispflag);
else % save the complete perfect matching graph
    [SavedGraphs,id] = TreeSaveGraphs(E2,SavedGraphs,id,dispflag);
end

end % function PMA_StochasticAlg_v1