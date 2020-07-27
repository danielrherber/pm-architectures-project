%--------------------------------------------------------------------------
% PMA_Change2PythonFolder.m
% Change current folder to /src/iso/python for code speedup
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function origdir = PMA_Change2PythonFolder(opts,toggleFlag,origdir)

if toggleFlag % change to python folder

    % original directory
    origdir = pwd;

    % python directory
    pydir = mfoldername('PMA_RemoveIsoLabeledGraphs','python');

    % change directory
    cd(pydir)

else % change to original directory

    % return to the original directory
    cd(origdir);

end

end