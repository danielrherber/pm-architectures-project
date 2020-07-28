%--------------------------------------------------------------------------
% PMA_DefaultOpts.m
% Default options for PM Architectures Project
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function opts = PMA_DefaultOpts(varargin)

% check if any options are provided
if isempty(varargin)
    opts = [];
else
    opts = varargin{1};
end

% algorithm for generate candidate graphs
if ~isfield(opts,'algorithm')
    % opts.algorithm = 'pm_full'; % generate all perfect matchings
    % opts.algorithm = 'pm_incomplete'; % some of the perfect matchings
    % opts.algorithm = 'tree_v1';
    % opts.algorithm = 'tree_v1_mex';
    % opts.algorithm = 'tree_v1_analysis';
    % opts.algorithm = 'tree_v1_stochastic';
    % opts.algorithm = 'tree_v8';
    % opts.algorithm = 'tree_v8_mex';
    % opts.algorithm = 'tree_v8_analysis';
    % opts.algorithm = 'tree_v8_stochastic';
    % opts.algorithm = 'tree_v10';
    % opts.algorithm = 'tree_v10_mex';
    % opts.algorithm = 'tree_v10_analysis';
    % opts.algorithm = 'tree_v10_stochastic';
    % opts.algorithm = 'tree_v11DFS';
    % opts.algorithm = 'tree_v11DFS_mex';
    % opts.algorithm = 'tree_v11DFS_analysis';
    % opts.algorithm = 'tree_v11BFS';
    % opts.algorithm = 'tree_v11BFS_mex';
    % opts.algorithm = 'tree_v11BFS_analysis';
    opts.algorithm = 'tree_v12DFS';
    % opts.algorithm = 'tree_v12DFS_mex';
    % opts.algorithm = 'tree_v12DFS_analysis';
    % opts.algorithm = 'tree_v12BFS';
    % opts.algorithm = 'tree_v12BFS_mex';
    % opts.algorithm = 'tree_v1BFS_analysis';
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
    opts.filterflag = true; % on
    % opts.filterflag = false; % off
end
opts.filterflag = logical(opts.filterflag); % ensure data type

% isomorphism checking method
if ~isfield(opts,'isomethod')
    % opts.isomethod = 'python'; % requires setup
    % opts.isomethod = 'py-igraph'; % requires setup
    % opts.isomethod = 'py-networkx'; % requires setup
    opts.isomethod = 'matlab'; % available in 2016b or later versions
    % opts.isomethod = 'None';
end
if strcmpi(opts.isomethod,'python')
    opts.isomethod = 'py-igraph'; % requires setup
end

% sorting flag
if ~isfield(opts,'sortflag')
    opts.sortflag = true; % on
    % opts.sortflag = false; % off
end
opts.sortflag = logical(opts.sortflag); % ensure data type

%--------------------------------------------------------------------------
% START: algorithm options
%--------------------------------------------------------------------------
% algorithms option structure
if ~isfield(opts,'algorithms')
    opts.algorithms = [];
end

% maximum number of graphs to preallocate for
if ~isfield(opts.algorithms,'Nmax')
    opts.algorithms.Nmax = uint64(1e5);
end
opts.algorithms.Nmax = uint64(opts.algorithms.Nmax); % ensure data type

% simple port-type isomorphism (BFS methods only)
if ~isfield(opts.algorithms,'filterflag')
    opts.algorithms.filterflag = opts.filterflag; % same as above
    % opts.algorithms.filterflag = true; % on
    % opts.algorithms.filterflag = false; % off
end
opts.algorithms.filterflag = logical(opts.algorithms.filterflag); % ensure data type

% maximum number of graphs to perform full isomorphism check (BFS methods only)
if ~isfield(opts.algorithms,'isoNmax')
    % opts.algorithms.isoNmax = uint64(inf); % no limit
    opts.algorithms.isoNmax = uint64(100); % 100 graph limit
end
opts.algorithms.isoNmax = uint64(opts.algorithms.isoNmax); % ensure data type

% full isomorphism check (BFS methods only)
if ~isfield(opts.algorithms,'isoflag')
    if strcmpi(opts.isomethod,'none')
        opts.algorithms.isoflag = false; % off
    elseif opts.algorithms.isoNmax == 0
        opts.algorithms.isoflag = false; % off
    else
        opts.algorithms.isoflag = true; % on
    end
end
opts.algorithms.isoflag = logical(opts.algorithms.isoflag); % ensure data type

% isomorphism checking option (BFS methods only)
if ~isfield(opts.algorithms,'isomethod')
    switch lower(opts.isomethod)
        case 'matlab'
            opts.algorithms.isomethod = uint8(1); % matlab
        case 'py-igraph'
            opts.algorithms.isomethod = uint8(2); % python igraph
        case 'py-networkx'
            opts.algorithms.isomethod = uint8(3); % python networkx
        otherwise
            opts.algorithms.isomethod = uint8(0); % none
    end
end
opts.algorithms.isomethod = uint8(opts.algorithms.isomethod); % ensure data type
%--------------------------------------------------------------------------
% END: algorithm options
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% START: plot options
%--------------------------------------------------------------------------
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

% randomize the plot ordering
if ~isfield(opts.plots,'randomize')
    % opts.plots.randomize = true; % randomized ordering
    opts.plots.randomize = false; % original ordering
end
opts.plots.randomize = logical(opts.plots.randomize); % ensure data type

% save the graphs to disk?
if ~isfield(opts.plots,'saveflag')
    % opts.plots.saveflag = true; % save the graphs
    opts.plots.saveflag = false; % don't save the graphs
end
opts.plots.saveflag = logical(opts.plots.saveflag); % ensure data type

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
    opts.plots.labelnumflag = true; % no
    % opts.plots.labelnumflag = false; % yes
end
opts.plots.labelnumflag = logical(opts.plots.labelnumflag); % ensure data type

% color library to use (see PMA_LabelColors.m)
if ~isfield(opts.plots,'colorlib')
    opts.plots.colorlib = 1; % ColorLibrary1
    % opts.plots.colorlib = 2; % ColorLibrary2
    % opts.plots.colorlib = @(L) customLib(L); % custom color library
end
%--------------------------------------------------------------------------
% END: plot options
%--------------------------------------------------------------------------

% controls displaying diagnostics to the command window
if ~isfield(opts,'displevel')
    % opts.displevel = uint8(3); % very verbose
    opts.displevel = uint8(2); % verbose
    % opts.displevel = uint8(1); % minimal
    % opts.displevel = uint8(0); % none
end
opts.displevel = uint8(opts.displevel); % ensure data type

% start the parallel pool
if strcmpi(opts.isomethod,'python')
    PMA_ParallelToggle('start-py',opts)
else
    PMA_ParallelToggle('start',opts)
end

% structured components default options
opts = PMA_STRUCT_DefaultOpts(opts);

% reorder fields
opts = orderfields(opts);

end