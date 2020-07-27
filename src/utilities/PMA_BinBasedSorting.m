%--------------------------------------------------------------------------
% PMA_BinBasedSorting.m
% Sort input vector based on bins
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function V = PMA_BinBasedSorting(V,B)

% obtain unique bins and locations
[~,IA,IC] = unique(B);

% go through each type
for k = 1:length(IA)

    % current bin indices
    b = IA(k) == IC;

    % sort current bin
    V(:,b) = sort(V(:,b),2);

end

end