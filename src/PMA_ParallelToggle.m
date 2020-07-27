%--------------------------------------------------------------------------
% PMA_ParallelToggle.m
% Open and close parallel pools without any command window outputs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function PMA_ParallelToggle(flags,varargin)

% initialize # of workers
nworkers = true;

% parse variable inputs
if ~isempty(varargin)

    % initialize
    errorstr = "PMA_ParallelToggle: inputs defined incorrectly";

    % parse size of the inputs
    if length(varargin) ~= 1
        error(errorstr)
    end

    % extract input
    in = varargin{1};

    % parse input data type
    if isstruct(in)

        % check if parallel field is present
        if isfield(in,'parallel')
            nworkers = in.parallel; % # of workers as an input
        else
            error(errorstr)
        end

    elseif islogical(in)

        nworkers = in;

    elseif isscalar(in)

        if in == 0
            nworkers = false; % do not start a parallel pool
        elseif in > 0
            nworkers = in; % # of workers as an input
        else
            error(errorstr)
        end

    end
else

end

% split up the flags
flagsSplit = strsplit(flags,'-');

% only if parallel computing is desired
if nworkers

    % check if we want to delete the parallel pool
    if all(ismember({'delete'},flagsSplit))

        % shutdown exist parallel pool
        delete(gcp('nocreate'));

    else
        % get current pool
        cpool = gcp('nocreate');

        % determine if we need to start a parallel pool
        startflag = false;
        if all(ismember({'start'},flagsSplit))
            if isempty(cpool)
                % start a new parallel pool since none exists
                startflag = true;
            elseif islogical(nworkers)
                % do not start a new pool because this one is fine
                startflag = false;
            else
                % check if the number of workers are correct
                startflag = cpool.NumWorkers ~= nworkers;
            end
        end

        % potentially start a new parallel pool
        if startflag

            % delete current pool
            O = evalc('delete(gcp(''nocreate''))');

            % initialize string
            str = 'parpool(';

            % check if nworkers is numeric
            if isnumeric(nworkers)
                str = [str,'nworkers,'];
            end

            % check if spmd is needed
            if all(ismember('spmd',flagsSplit))
                str = [str,'''SpmdEnabled'',true,'];
            else
                str = [str,'''SpmdEnabled'',false,'];
            end

            % complete command
            str = [str(1:end-1),');'];

            % start a parallel pool
            O = evalc(str);

        end
    end

    % add python executable to the worker's workspace
    if all(ismember({'py'},flagsSplit))
        [~, executable, ~] = pyversion;
        try
            O = evalc(['pctRunOnAll pyversion(''',executable,''');']);
        catch
            % base workspace will fail if python is already loaded
        end
    end
end
end