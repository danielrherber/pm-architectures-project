%--------------------------------------------------------------------------
% UniqueUsefulGraphs.m
% Given an architecture problem, find the set of unique useful graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts)

    % set opts with defaults if not specified
    opts = DefaultOpts(opts);

    % generate feasible graphs
    Graphs = GenerateFeasibleGraphs(C,R,P,NSC,opts);

    % check for colored graph isomorphisms
    [FinalGraphs,~] = RemovedColoredIsos(Graphs,opts);

    % plot the unique designs
    plotDesign(FinalGraphs,NSC,opts)
    
end