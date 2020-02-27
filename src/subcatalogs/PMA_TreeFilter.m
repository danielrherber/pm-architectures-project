%--------------------------------------------------------------------------
% PMA_TreeFilter.m
% Subcatalog checks for the existence of a graph if it is required to have
% simple edges, no loops, and be connected (tree graph condition)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [Ls,Ps,Rs] = PMA_TreeFilter(Ls,Ps,Rs)

% total number of components (vertices)
Ntotal = sum(Rs,2);

%--------------------------------------------------------------------------
% lower bound: tree graph condition
%--------------------------------------------------------------------------
% total number of ports (degrees)
Ptotal = sum(Ps.*Rs,2);

% failure condition (tree graph condition)
failed = Ptotal < 2*(Ntotal-1);

% remove failed
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = [];

end