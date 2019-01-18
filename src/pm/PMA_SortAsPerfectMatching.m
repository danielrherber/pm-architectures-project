%--------------------------------------------------------------------------
% PMA_SortAsPerfectMatching.m
% Given a set of edges, sort the edge set to fulfill the requirements of a
% perfect matching
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function G = PMA_SortAsPerfectMatching(G)

    G = fliplr(G); % flip so even and odd vertices switch
    N = size(G,1); % number of edge sets
    n = size(G,2); % number of vertices
    Vo = G(:,1:2:n-1); % odd index vertices
    Ve = G(:,2:2:n); % even index vertices
    [Vo,Io] = sort(Vo,2,'descend'); % sort the odd index vertices
    Ir = repmat((1:N)',1,n/2); % create row indices
    I = sub2ind([N n],Ir,Io); % get linear indices
    Ve = Ve(I); % sort the even index vertices
    G(:,1:2:n-1) = Vo; % assign sorted odd index vertices
    G(:,2:2:n) = Ve; % assign sorted even index vertices

end