%--------------------------------------------------------------------------
% Structured_DefaultOpts.m
% Default options for enumeration of graphs with structured components
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli, Undergraduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function opts = Structured_DefaultOpts(opts)

    % check if structured field is present
    if ~isfield(opts,'structured')
        opts.structured = [];
    end

    % isomorphism checking method
    if ~isfield(opts.structured,'isomethod')
        if ~isfield(opts,'isomethod')
            % opts.structured.isomethod = 'Python'; % requires setup
            opts.structured.isomethod = 'Matlab'; % available in 2016b or later versions
            % opts.structured.isomethod = 'None';
        else
            opts.structured.isomethod = opts.isomethod;
        end
    end

    % perform simple checks on structured graphs during isomorphism tests
    if ~isfield(opts.structured,'simplecheck')
        % opts.structured.simplecheck = 1; % use the simple checks
        opts.structured.simplecheck = 0; % don't use the simple checks
    elseif opts.structured.simplecheck
        error('*** this method is broken, please do not use ***')
    end

    % check for isomorphisms during the enumeration procedure
    if ~isfield(opts.structured,'isotree')
        opts.structured.isotree = 'AIO'; % all-in-one method
        % opts.structured.isotree = 'LOE'; % level-order method
    end
   
    % reordering of the labels before enumeration
    if ~isfield(opts.structured,'ordering')
        opts.structured.ordering = 'None'; % no ordering
        % opts.structured.ordering = 'TA'; % 
        % opts.structured.ordering = 'TD'; % 
        % opts.structured.ordering = 'PD'; % 
        % opts.structured.ordering = 'PA'; % 
        % opts.structured.ordering = 'RA'; % 
        % opts.structured.ordering = 'RD'; % 
    end

    % control parallel computing
    if ~isfield(opts.structured,'parallel')
        if ~isfield(opts,'isomethod')
            opts.structured.parallel = 0; % no parallel computing
            % opts.structured.parallel = 4; % parallel computing with 4 workers
            % opts.structured.parallel = 8; % parallel computing with 8 workers
            % opts.structured.parallel = 12; % parallel computing with 12 workers
        else
            opts.structured.parallel = opts.parallel;
        end
    end

end