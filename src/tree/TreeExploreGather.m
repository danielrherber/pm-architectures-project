%--------------------------------------------------------------------------
% TreeExploreGather.m
% Complete problem set up and use a particular generation method to 
% generate a fixed number of graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [M,I,N] = TreeExploreGather(counts,A,R,opts,N)

M = zeros(N,sum(counts),'uint8'); % initialize matchings matrix
M0 = zeros(1,sum(counts),'uint8');
cp = cumsum(counts)+1;

I = zeros(N,1);

A = ExpandPossibleAdj(A,R,opts);

% generate graphs randomly
for i = 1:N
    [O,~] = TreeExploreCreate1(counts,[],M0,cp,0,A);
    if ~all(O==0,2)
        O = SortAsPerfectMatching(O); % sort M to make them perfect matchings
        I(i) = InversePerfectMatchings(O);
        M(i,:) = O;
    else
        
    end
end

[M,IA] = unique(M,'rows'); % extract on the unique rows

I = I(IA);

if all(M(1,:)==0,2)
    M(1,:) = [];
    I(1) = [];
end

N = size(M,1);

end