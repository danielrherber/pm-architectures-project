%--------------------------------------------------------------------------
% ParallelToggle.m
% Open and close parallel pools without any command window outputs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function ParallelToggle(opts,flags)

    % only if parallel computing is desired
    if (opts.parallel > 0)
        % split up the flags
        flagsSplit = strsplit(flags,'-');

        % check if we want to delete the parallel pool
        if all(ismember({'delete'},flagsSplit))
            % shutdown exist parallel pool
            delete(gcp('nocreate'));
        else
            % get current pool
            cpool = gcp('nocreate');

            % determine if we need to start a parallel pool
            startflag = 0;
            if all(ismember({'start'},flagsSplit))
                if isempty(cpool)
                    % start a new parallel pool since none exists
                    startflag = 1;
                else
                    % check if the number of workers are correct
                    startflag = cpool.NumWorkers ~= opts.parallel;
                end
            end
            
            % potentially start a new parallel pool
            if startflag
                % delete current pool
                O = evalc('delete(gcp(''nocreate''))');

                % start a parallel pool
                if all(ismember({'start','spmd'},flagsSplit))
                    % start a parallel pool,
                    O = evalc('parpool(opts.parallel,''SpmdEnabled'',true);');
                elseif all(ismember({'start'},flagsSplit))
                    % start a parallel pool
                    O = evalc('parpool(opts.parallel,''SpmdEnabled'',false);');                
                end

            end
        end

        % add python executable to the worker's workspace
        if all(ismember({'py'},flagsSplit))
            [~, executable, ~] = pyversion;
            try
                eval(['pctRunOnAll pyversion(''',executable,''');']);
            catch
                % base workspace will fail if python is already loaded
            end
        end

    else
        % shutdown existing parallel pool
        O = evalc('delete(gcp(''nocreate''))');
    end

end