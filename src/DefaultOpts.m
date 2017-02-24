%--------------------------------------------------------------------------
% DefaultOpts.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function opts = DefaultOpts(opts)

    % algorithm for generate candidate graphs
    if ~isfield(opts,'algorithm')
%         opts.algorithm = 'tree_v5';
%         opts.algorithm = 'tree_v4';
%         opts.algorithm = 'tree_v3';
%         opts.algorithm = 'tree_v2';
        opts.algorithm = 'tree_v1';
%         opts.algorithm = 'tree_v4_analysis';
%         opts.algorithm = 'tree_v3_analysis';
%         opts.algorithm = 'tree_v2_analysis';
%         opts.algorithm = 'tree_v1_analysis';
%         opts.algorithm = 'pm_full'; % generate all perfect matchings
%         opts.algorithm = 'pm_incomplete'; % some of the perfect matchings        
    end

    % maximum number of graphs to preallocate for
    if ~isfield(opts,'Nmax')
        opts.Nmax = 1e7;
    end
    
    % control parallel computing
    if ~isfield(opts,'parallel')
        opts.parallel = 0; % no parallel computing
%         opts.parallel = 1; % parallel computing with max number of workers
    end

    % initial port type isomorphism filter
    if ~isfield(opts,'portisofilter')
        opts.portisofilter = 1; % on
    % 	opts.portisofilter = 0; % off
    end

    % plot function type
    if ~isfield(opts,'plotfun')
        opts.plotfun = 'circle';
    %     opts.plotfun = 'bgl';
    %     opts.plotfun = 'bio';
    end

    % custom network structure constraint function
    if ~isfield(opts,'customfun')
        % none by default
    end

    % maximum number of graphs to display/save
    if ~isfield(opts,'plotmax')
        opts.plotmax = 10;
    end
    
    % save the graphs to disk?
    if ~isfield(opts,'save')
%         opts.save = 1; % save the graphs
        opts.save = 0; % don't save the graphs
    end

    % name of the example
    if ~isfield(opts,'name')
        opts.name = mfilename; 
    end

    % path for saving figures
    if ~isfield(opts,'path')
        opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); 
    end

    % isomorphism checking method
    if ~isfield(opts,'isomethod')
%         opts.isomethod = 'Python';
        opts.isomethod = 'Matlab'; % available in 2016b or later versions
    %     opts.isomethod = 'None';
    end

    % controls displaying diagnostics to the command window
    if ~isfield(opts,'dispflag')
        opts.dispflag = 1; % on
    %     opts.dispflag = 0; % off
    end
    
end