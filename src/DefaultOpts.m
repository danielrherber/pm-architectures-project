%--------------------------------------------------------------------------
% DefaultOpts.m
% Default options for PM Architectures Project
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function opts = DefaultOpts(varargin)

    % check if any options are provided
    if isempty(varargin)
        opts = [];
    else
        opts = varargin{1};
    end

    % algorithm for generate candidate graphs
    if ~isfield(opts,'algorithm')
        % opts.algorithm = 'tree_v1';
        % opts.algorithm = 'tree_v1_mex';
        % opts.algorithm = 'tree_v1_analysis';
        opts.algorithm = 'tree_v8';
        % opts.algorithm = 'tree_v8_mex';
        % opts.algorithm = 'tree_v10';
        % opts.algorithm = 'pm_full'; % generate all perfect matchings
        % opts.algorithm = 'pm_incomplete'; % some of the perfect matchings        
    end

    % maximum number of graphs to preallocate for
    if ~isfield(opts,'Nmax')
        opts.Nmax = 1e7;
    end
    
    % control parallel computing
    if ~isfield(opts,'parallel')
        opts.parallel = 0; % no parallel computing
        % opts.parallel = 4; % parallel computing with 4 workers
        % opts.parallel = 8; % parallel computing with 8 workers
        % opts.parallel = 12; % parallel computing with 12 workers
    end

    % initial port type isomorphism filter
    if ~isfield(opts,'filterflag')
        opts.filterflag = 1; % on
        % opts.filterflag = 0; % off
    end

    % custom network structure constraint function
    if ~isfield(opts,'customfun')
        % none by default
    end

    % custom subcatalog filter function
    if ~isfield(opts,'subcatalogfun')
        % none by default
    end
    
    % isomorphism checking method
    if ~isfield(opts,'isomethod')
        % opts.isomethod = 'Python'; % requires setup
        opts.isomethod = 'Matlab'; % available in 2016b or later versions
        % opts.isomethod = 'None';
    end
    
    % sorting flag
    if ~isfield(opts,'sortflag')
        opts.sortflag = 1; % on
        % opts.sortflag = 0; % off
    end
    
    %----------------------------------------------------------------------
    % START: plot options
    %----------------------------------------------------------------------
    % plot option structure
    if ~isfield(opts,'plots')
        opts.plots = [];
    end
    
    % plot function type
    if ~isfield(opts.plots,'plotfun')
        % opts.plots.plotfun = 'circle';
        % opts.plots.plotfun = 'bgl';
        % opts.plots.plotfun = 'bio';
        opts.plots.plotfun = 'matlab';
        % opts.plots.plotfun = 'matlab2018b';
    end
    
    % maximum number of graphs to display/save
    if ~isfield(opts.plots,'plotmax')
        opts.plots.plotmax = 10;
    end
    
    % save the graphs to disk?
    if ~isfield(opts.plots,'saveflag')
        % opts.plots.saveflag = 1; % save the graphs
        opts.plots.saveflag = 0; % don't save the graphs
    end

    % name of the example
    if ~isfield(opts.plots,'name')
        opts.plots.name = mfilename; 
    end

    % path for saving figures
    if ~isfield(opts.plots,'path')
        opts.plots.path = mfoldername(mfilename('fullpath'),[]); 
    end
    
    % file type for exported figures
    if ~isfield(opts.plots,'outputtype')
        % opts.plots.outputtype = 'pdf'; 
        opts.plots.outputtype = 'png'; 
    end

    % add replicate numbers when plotting
    if ~isfield(opts.plots,'labelnumflag')
        opts.plots.labelnumflag = 0; % no
        % opts.plots.labelnumflag = 1; % yes
    end
    %----------------------------------------------------------------------
    % END: plot options
    %----------------------------------------------------------------------

    % controls displaying diagnostics to the command window
    if ~isfield(opts,'displevel')
        opts.displevel = 2; % verbose
        % opts.displevel = 1; % minimal
        % opts.displevel = 0; % none
    end
    opts.displevel = uint8(opts.displevel); % update data type
    
    % start the parallel pool
    if strcmpi(opts.isomethod,'python')
        PMA_ParallelToggle(opts,'start-py')
    else
        PMA_ParallelToggle(opts,'start')
    end
    
    % structured components default options
    opts = Structured_DefaultOpts(opts);
    
end