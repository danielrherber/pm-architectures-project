%--------------------------------------------------------------------------
% PMA_PortIsoFilter.m
% Apply the port-type isomorphism filter to remove isomorphic graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [M,I,N] = PMA_PortIsoFilter(M,I,phi,opts)

% substitute values in data array, same as changem
Msum = M;
oldval = 1:length(phi);
for k = 1:numel(phi)
    Msum(M == oldval(k)) = phi(k);
end

% obtain the unique connected component adjacency matrices
options = 1;
switch options 
    case 1
        % note, this is really a fix for the port-type iso filter
        % based on connected components graph being exactly the same
        n = length(phi)/2;
        
        % fixed size of the connected components adjacency matrix
        N = max(phi);
        
        % convert multiple subscripts to linear index
        P = zeros(size(Msum,1),n,'uint8'); % initialize
        for k = 1:n
            P(:,k) = N*(Msum(:,2*k)-1) + Msum(:,2*k-1); % similar to sub2ind
        end
        
        % sort the elements in each row
        P = sort(P,2,'descend'); % descending is a bit faster

        % obtain the unique connected component adjacency matrices
        [~,IA] = unique(P,'rows');

    case 2 % see the note above
        % extract on the unique rows
        [~,IA] = unique(Msum,'rows');

end

% get new set of graphs
M = M(IA,:);

% get pms of new set of graphs
I = I(IA);

% total number of graphs remaining
N = size(M,1);

% output some stats to the command window
if (opts.displevel > 1) % verbose
    ttime = toc; % stop timer
    disp(['Only ',num2str(N), ' remaining after initial port-type isomorphism check in ', num2str(ttime),' s'])
end

end