%--------------------------------------------------------------------------
% SortAsPerfectMatching.m
% Given a set of edges, sort the edge set to fulfill the requirements of a
% perfect matching
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------
function M = SortAsPerfectMatching(M)

M = fliplr(M);

N = size(M,2);
Mtemp = ones(1,N);
% sort to make a perfect matching
for i = 1:size(M,1)
    odd = M(i,1:2:N-1);
    [oddsort,Iodd] = sort(odd,'descend');
    Mtemp(1,1:2:N-1) = oddsort;
    Mtemp(1,2:2:N) = M(i,Iodd*2);
    M(i,:) = Mtemp;
end