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

    % change current folder
    origdir = PMA_ChangeFolder(opts,true,[]);
    
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
        [P,R,C,NSC,Sorts] = ReorderCRP(P,R,C,NSC,opts);
        
        % generate feasible graphs
        Graphs = GenerateFeasibleGraphs(C,R,P,NSC,opts,Sorts);

        % check for colored graph isomorphisms
        FinalGraphs = PMA_RemoveIsoColoredGraphs(Graphs,opts);
    end

    % structured graphs
    if isfield(NSC,'S')
        FinalGraphs = Structured_UniqueUsefulGraphs(C,R,P,NSC,opts,FinalGraphs);    
    end    
    
    % plot the unique designs
    PMA_PlotGraphs(FinalGraphs,NSC,opts)
    
    % change to original directory
    PMA_ChangeFolder(opts,false,origdir);

end