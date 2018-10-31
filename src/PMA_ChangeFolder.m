%--------------------------------------------------------------------------
% PMA_ChangeFolder.m
% Change current folder based on inputs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function origdir = PMA_ChangeFolder(opts,toggleFlag,origdir)

    % for python, change current folder to /src/iso/python for code speedup
    % if strcmpi(opts.isomethod,'python')
        if toggleFlag % change to python folder
            % original directory
            origdir = pwd;
            
            % python directory
            pydir = mfoldername('PMA_RemoveIsoColoredGraphs','python');
            
            % change directory
            cd(pydir)
        else % change to original directory
            % return to the original directory
            cd(origdir);
        end        
    % end
end