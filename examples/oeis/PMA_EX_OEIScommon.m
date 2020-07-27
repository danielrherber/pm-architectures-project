%--------------------------------------------------------------------------
% PMA_EX_OEIScommon.m
% Common code for the OEIS examples
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
switch flag
    %----------------------------------------------------------------------
    case 'inputs'
    % extract n
    n = varargin{1};

    % check if opts provided
    if length(varargin) == 2

        %  extract opts
        opts2 = varargin{2};

        % combine
        if ~isempty(opts2)
            f = fieldnames(opts2);
            for k = 1:length(f)
                opts.(f{k}) = opts2.(f{k});
            end
        end
    end

    % make silent
    opts.plots.plotmax = 0;
    opts.displevel = 0;

    % start timer
    t1 = tic;
    %----------------------------------------------------------------------
    case 'outputs'
    if isempty(varargin)
        disp("correct?")
        disp(string(isequal(length(G1),n2)))
    else
        varargout{3} = toc(t1); % timer
        varargout{1} = n;
        varargout{2} = isequal(length(G1),n2);
        varargout{4} = opts;
    end
    %----------------------------------------------------------------------
end