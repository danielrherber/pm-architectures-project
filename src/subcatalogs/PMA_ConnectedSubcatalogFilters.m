%--------------------------------------------------------------------------
% PMA_ConnectedSubcatalogFilters.m
% Subcatalog checks for the existence of a graph if it is required to be a
% connected graph with no loops (lower bound is the condition for a tree
% graph and the upper bound uses the Erdos-Gallai theorem)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [Ls,Ps,Rs] = PMA_ConnectedSubcatalogFilters(Ls,Ps,Rs)

% total number of components (vertices)
Ntotal = sum(Rs,2);

%--------------------------------------------------------------------------
% lower bound: tree graph condition
%--------------------------------------------------------------------------
% total number of ports (degrees)
Ptotal = sum(Ps.*Rs,2);

% failure condition
failed = Ptotal < 2*(Ntotal-1);

% remove failed
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = [];
Ntotal(failed,:) = [];
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% upper bound: Erdos-Gallai theorem
%--------------------------------------------------------------------------
% initialize
failed = false(size(Ps,1),1);

% initial term sequence
S = cumsum(0:2:2*max(Ntotal));

% sort all port vectors
[Pst,Is] = sort(Ps,2,'descend');

% go through each subcatalog
for idx = 1:size(Ps,1)
    % sort replicate vectors
    Rst = Rs(idx,Is(idx,:));

    % replicate elements (largest values should be first)
    Ds = repelem(Pst(idx,:),Rst);

    % total number of components (vertices)
    n = Ntotal(idx);

    % cumulative sum of the decreasing degree sequence
    C1 = cumsum(Ds);

    % go through each vertex
    for k = 1:Ntotal(idx)
        % failure condition
        if C1(k) > S(k) + sum(min(Ds(k+1:n),k))
            failed(idx) = true;
            break;
        end
    end
end

% remove failed
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = [];
%--------------------------------------------------------------------------

end