%--------------------------------------------------------------------------
% PMA_STRUCT_RemovedColoredIsos.m
% Given a set of structured labeled graphs, determine the set of
% nonisomorphic structured labeled graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = PMA_STRUCT_RemovedColoredIsos(Graphs,opts,varargin)

% get additional inputs for the simple checks
if ~isempty(varargin)
    iStruct = varargin{1};
    np = varargin{2};
end

% store display level
displevel = opts.displevel;

% suppress displaying
opts.displevel = 0;

if ~isempty(Graphs) % if Graphs isn't empty
    if isfield(opts.structured,'isomethod') % if opts.isomethod is present
        % different isomorphism check options
        switch lower(opts.structured.isomethod) % case insensitive
            %--------------------------------------------------------------
            case 'matlab' % Matlab implementation
            try
                % check if we should use the simple checks
                if opts.structured.simplecheck == 1
                    FinalGraphs = PMA_STRUCT_RemovedColoredIsosMatlabSimple(Graphs,opts,iStruct,np);
                else
                    FinalGraphs = PMA_RemoveIsoLabeledGraphs(Graphs,opts);
                end
            catch
                msg = sprintf(' An error occurred with the matlab option \n Definitely need MATLAB version R2016b or newer');
                error(msg)
            end
            %--------------------------------------------------------------
            case {'python','py-igraph'} % Python implementation
%             try
                % check if we should use the simple checks
                if opts.structured.simplecheck == 1
                    FinalGraphs = PMA_STRUCT_RemovedColoredIsosPythonSimple(Graphs,opts,iStruct,np);
                else
                    FinalGraphs = PMA_RemoveIsoLabeledGraphs(Graphs,opts);
                end
%             catch
%                 msg = sprintf(' An error occurred with the python option \n Definitely need a proper python install with igraph');
%                 error(msg)
%             end
            %--------------------------------------------------------------
            case 'none' % don't check for labeled isomorphisms
            FinalGraphs = PMA_RemoveIsoLabeledGraphs(Graphs,opts);
            %--------------------------------------------------------------
        end
    end
else
    FinalGraphs = []; % report empty if no graphs present
end

% restore the original display level
opts.displevel = displevel;

end