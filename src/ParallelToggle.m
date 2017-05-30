%--------------------------------------------------------------------------
% ParallelToggle.m
% Open and close parpools without any command window outputs
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

            % delete current pool
            O = evalc('delete(gcp(''nocreate''))');

            % start or stop the pool
            if all(ismember({'start','spmd'},flagsSplit))
                % start a parallel pool,
                O = evalc('parpool(opts.parallel,''SpmdEnabled'',true);');
            elseif all(ismember({'start'},flagsSplit))
                % start a parallel pool
                O = evalc('parpool(opts.parallel,''SpmdEnabled'',false);');
            elseif all(ismember({'delete'},flagsSplit))
                % shutdown exist parallel pool
                delete(gcp('nocreate'));
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