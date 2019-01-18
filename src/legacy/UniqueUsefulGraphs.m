%--------------------------------------------------------------------------
% UniqueUsefulGraphs.m
% Given an architecture class specification, find the set of unique,
% feasible graphs
%--------------------------------------------------------------------------
% NOTE: purpose of this function is only to maintain compatibilty with a
% previous function name
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts)

    % call new function
    FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

end