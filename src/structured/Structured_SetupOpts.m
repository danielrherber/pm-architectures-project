%--------------------------------------------------------------------------
% Structured_SetupOpts.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli,Undergraduate Student,University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function opts = Structured_SetupOpts
    %======Default Opts for the Component Graphs =======
    opts.algorithm = 'tree_v8';
    opts.Nmax = 1e7; % maximum number of graphs to preallocate for
    opts.parallel = 7; % 0 to disable parallel computing, otherwise max number of workers
    opts.filterflag = 1; 
    opts.plotfun = 'bgl';
    opts.plotmax = 0;
    opts.saveflag = 0; % save graphs to disk
    opts.name = 'test'; % name of the example
    opts.path = []; % path to save figures to
    opts.isomethod = 'python';
    opts.isocheck = 1;
    opts.displevel= 0;
     %==================================================================
     
    %======Eliminate isomorphic graphs in structured graphs set? =======
    opts.structured.isocheck = 1;
    %opts.structured.isocheck = 0;
    %==================================================================
    
    %======Do simple check for structured Graphs before doing the whole?==
    opts.structured.simpleCheck = 0;
    %opts.structured.simpleCheck = 1;
    %==================================================================
    
    %======Which method to use when doing isochecking=========
    opts.structured.isomethod = 'AIO';
    %opts.structured.method = 'LOE';
    %==================================================================
    
    
    %======Do we want to reorder the labels before doing isocheck=========
    opts.structured.order = 'None';
    %opts.structured.order = 'TA';
    %opts.structured.order = 'TD';
    %opts.structured.order = 'PD';
    %opts.structured.order = 'PA';
    %opts.structured.order = 'RA';
    %opts.structured.order = 'RD';
    
    %+++++++++Note: This option is useful in LOE method only++++++++++++
    %==================================================================
    
    %======== Do we want to parellel computing? =======================
    opts.structured.parellel = 7;
    %==================================================================
end

