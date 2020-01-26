%--------------------------------------------------------------------------
% PMA_ColorBasedSorting.m
%
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function V = PMA_ColorBasedSorting(V,Ln)
    % sort degrees lists with respect to labels
    [VC,VIA,VIC] = unique(Ln);

    % go through each component type
    for i = 1:length(VC)
        % find all components of the current type
        Ncomp = sum(VIC==i);

        % sort
        V(:,VIA(i):VIA(i)+Ncomp-1) = sort(V(:,VIA(i):VIA(i)+Ncomp-1),2);
    end
end