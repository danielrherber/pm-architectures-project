%--------------------------------------------------------------------------
% PMA_UniqueFeasibleGraphs.m
% Given an architecture class specification, find the set of unique,
% feasible graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [FinalGraphs,opts] = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts)

% set opts with defaults if not specified
opts = PMA_DefaultOpts(opts);

% set NSC with defaults if not specified
[NSC,L,P,R] = PMA_DefaultNSC(NSC,L,P,R);

% change current folder
origdir = PMA_Change2PythonFolder(opts,true,[]);

% potentially start the timer
if (opts.displevel > 0)
    tic % start timer
end

% generate unique, feasible graphs using subcatalogs
FinalGraphs = PMA_GenerateWithSubcatalogs(L,R,P,NSC,opts);

% structured graphs
if isfield(NSC,'S')
    FinalGraphs = PMA_STRUCT_UniqueUsefulGraphs(L,R,P,NSC,opts,FinalGraphs);
end

% plot the unique designs
PMA_PlotGraphs(FinalGraphs,NSC,opts)

% change to original directory
PMA_Change2PythonFolder(opts,false,origdir);

end