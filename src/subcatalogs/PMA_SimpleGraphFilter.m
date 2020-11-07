 %--------------------------------------------------------------------------
% PMA_SimpleGraphFilter.m
% Subcatalog checks for the existence of a graph if it is required to have
% simple edges and no loops (Erdos-Gallai theorem)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [Ls,Ps,Rs] = PMA_SimpleGraphFilter(Ls,Ps,Rs)

% total number of components (vertices)
Ntotal = sum(Rs,2);

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

        % failure condition (Erdos-Gallai theorem)
        if C1(k) > S(k) + sum(min(Ds(k+1:n),k))
            failed(idx) = true;
            break;
        end
    end
end

% remove failed
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = [];

end