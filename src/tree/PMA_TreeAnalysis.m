%--------------------------------------------------------------------------
% PMA_TreeAnalysis.m
% General operations for analysis version of the tree algorithms
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
switch option
    %----------------------------------------------------------------------
    case 1 % obtain global variables
    global node nodelist labellist feasiblelist
    %----------------------------------------------------------------------
    case 2 % add node to tree and check if it was allowable
    nodelist = [nodelist,prenode];
    labellist = [labellist,[iL;iR]];
    feasiblelist = [feasiblelist,1];
    node = node + 1;

    if logical(V(iR))~=logical(Vallow(iR))
        feasiblelist(end) = 0;
        continueflag = true;
    else
        continueflag = false;
    end
    %----------------------------------------------------------------------
    case 3 % saturated subgraph constraint violated
    feasiblelist(end) = 0;
end