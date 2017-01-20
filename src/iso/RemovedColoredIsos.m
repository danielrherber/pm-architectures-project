%--------------------------------------------------------------------------
% RemovedColoredIsos.m
% Given a set of colored graphs, determine the set of nonisomorphic colored
% graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [FinalGraphs,typearray] = RemovedColoredIsos(Graphs,opts)

    if ~isempty(Graphs) % if Graphs isn't empty
        if isfield(opts,'isomethod') % if opts.isomethod is present
            % different isomorphism check options
            switch lower(opts.isomethod) % case insensitive
                %----------------------------------------------------------
                case 'matlab' % Matlab implementation
                    if exist('isomorphism','file') % is file correct?  
                        [FinalGraphs,typearray] = RemovedColoredIsosMatlab(Graphs,opts);
                    else
                        error('Need MATLAB version R2016b or newer for Matlab isomethod')
                    end
                %----------------------------------------------------------
                case 'python' % Python implementation
                    [FinalGraphs,typearray] = RemovedColoredIsosPython(Graphs,opts);
                %----------------------------------------------------------
                case 'none' % don't check for colored isomorphisms
                    if opts.dispflag
                        disp('Warning: colored isomorphisms may be present');
                        disp('To fix, pick an isomorphism checking method');
                        FinalGraphs = Graphs;
                        typearray = [];
                    end
                %----------------------------------------------------------
            end
        else % if no opts.isomethod field, will remove when defaults are enabled
            if opts.dispflag
                disp('Warning: colored isomorphisms may be present');
                disp('To fix, pick an isomorphism checking method');
                FinalGraphs = Graphs;
                typearray = [];
            end
        end
    else
        FinalGraphs = []; % report empty if no graphs present
        typearray = [];
    end

end