%--------------------------------------------------------------------------
% SortAsPerfectMatching.m
% Given a set of edges, sort the edge set to fulfill the requirements of a
% perfect matching
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function M = SortAsPerfectMatching(M)

    M = fliplr(M);
    N = size(M,2);
    odd = M(:,1:2:N-1);
    % sort to make a perfect matching
    for k = 1:size(M,1)
        [oddsort,Iodd] = sort(odd(k,:),'descend');
        M(k,1:2:N-1) = oddsort;
        M(k,2:2:N) = M(k,Iodd*2);
    end