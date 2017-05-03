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

    % set NSC with defaults if not specified
    NSC = DefaultNSC(NSC,P);

    % potentially start the timer
    if (opts.displevel > 0)
        tic % start timer
    end
    
    % determine if we should use subcatalogs or a single catalog
    % subcatalogs if there are any mandatory components or R.min is defined
    if NSC.flag.Mflag || isfield(R,'min')
        % generate unique, feasible graphs
        FinalGraphs = GenerateWithSubcatalogs(C,R,P,NSC,opts);
        
    else % use single catalog
        % sort {C, R, P} to be better suited for enumeration
        [P,R,C,NSC] = ReorderCRP(P,R,C,NSC,opts);
        
        % generate feasible graphs
        Graphs = GenerateFeasibleGraphs(C,R,P,NSC,opts);

        % check for colored graph isomorphisms
        FinalGraphs = RemovedColoredIsos(Graphs,opts);
    end

    % plot the unique designs
    plotDesign(FinalGraphs,NSC,opts)
    
end