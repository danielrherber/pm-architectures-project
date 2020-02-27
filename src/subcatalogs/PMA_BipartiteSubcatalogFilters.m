%--------------------------------------------------------------------------
% PMA_BipartiteSubcatalogFilters.m
% Subcatalog checks for the existence of a bipartite graph
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [Ls,Rs,Ps] = PMA_BipartiteSubcatalogFilters(L,Ls,Rs,Ps,NSC,opts)

% find index of first b type components
nb = find(~NSC.directA(:,1),1,'last')+1; % NOTE: not very robust

%--------------------------------------------------------------------------
% 1st filter: equal number of a and b ports
%--------------------------------------------------------------------------
% a component types
Ia = (Ls<nb); % locations
Rsa = Rs.*Ia; % replicates
Psa = Ps.*Ia; % ports
Npa = sum(Rsa.*Psa,2); % total ports

% b component types
Ib = (Ls>=nb); % locations
Rsb = Rs.*Ib; % replicates
Psb = Ps.*Ib; % ports
Npb = sum(Rsb.*Psb,2); % total ports

% condition
passed = Npa == Npb;

% extract
Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% 2nd filter: Gale–Ryser theorem
%--------------------------------------------------------------------------
% initialize
failed = false(size(Ps,1),1);

% a component types
Ia = (Ls<nb); % locations
Rsa = Rs.*Ia; % replicates
Psa = Ps.*Ia; % ports

% b component types
Ib = (Ls>=nb); % locations
Rsb = Rs.*Ib; % replicates
Psb = Ps.*Ib; % ports

% sort all port vectors
[Psat,Is] = sort(Psa,2,'descend');

% go through each subcatalog
for idx = 1:size(Ps,1)
    % sort replicate vectors
    Rsat = Rsa(idx,Is(idx,:));

    % a replicate elements (largest values should be first)
    Das = repelem(Psat(idx,:),Rsat);

    % b replicate elements
    Dbs = repelem(Psb(idx,:),Rsb(idx,:));

    % go through each entry in a degree sequence
    for k = 1:length(Das)
        % failure condition
        if sum(Das(1:k)) > sum(min(Dbs,k))
            failed(idx) = true;
            break;
        end
    end

end

% remove failed
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = [];

end