%--------------------------------------------------------------------------
% INSTALL_PM_Architectures_Project
% This scripts helps you get the PM Architectures Project up and running
%--------------------------------------------------------------------------
% Automatically adds project files to your MATLAB path, downloads the
% required MATLAB File Exchange submissions, checks your Python setup, 
% and opens an example.
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function INSTALL_PM_Architectures_Project

	warning('off','MATLAB:dispatcher:nameConflict');

	% Add project contents to path
	AddProjectContents

	% FX submissions
	FXSubmissions

    % Check Matlab's isomorphism function
    CheckMatlabIsomorphismFunction
    
	% Python
	PythonSetupCheck

	% Add project contents to path again
	AddProjectContents

	% Open example
	OpenExample 

	warning('on','MATLAB:dispatcher:nameConflict');

end
%--------------------------------------------------------------------------
function AddProjectContents
	disp('--- Adding project contents to path')
	disp(' ')

	fullfuncdir = which(mfilename('fullpath'));
	projectdir = fullfile(fileparts(fullfuncdir));
	addpath(genpath(projectdir)) % add contents
end
%--------------------------------------------------------------------------
function FXSubmissions
	disp('--- Obtaining required MATALB File Exchange submissions')

	ind = 0;

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/10922/versions/2/download/zip/matlab_bgl-4.0.1.zip';
	zips(ind).name = 'MFX 10922';
	zips(ind).test = 'bfs';

	ind = ind + 1;
	zips(ind).url = 'https://github.com/altmany/export_fig/archive/master.zip';
	zips(ind).name = 'MFX 23629';
	zips(ind).test = 'export_fig';

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/29438/versions/3/download/zip/cycleCountBacktrack.zip';
	zips(ind).name = 'MFX 29438';
	zips(ind).test = 'cycleCountBacktrack';

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/40397/versions/7/download/zip/mfoldername_v2.zip';
	zips(ind).name = 'MFX 40397';
	zips(ind).test = 'mfoldername';

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/44673/versions/2/download/zip/dispstat.zip';
	zips(ind).name = 'MFX 44673';
	zips(ind).test = 'dispstat';

	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/47246/versions/3/download/zip/tint.zip';
	zips(ind).name = 'MFX 47246';
	zips(ind).test = 'tint';

	% obtain full function path
	full_fun_path = which(mfilename('fullpath'));
	outputdir = fullfile(fileparts(full_fun_path),'include\');

	% download and unzip
	DownloadWebZips(zips,outputdir)

	disp(' ')
end
%--------------------------------------------------------------------------
% download and unzip weblinks that contain zip files
function DownloadWebZips(zips,outputdir)
    for k = 1:length(zips)
        % first check if the test file is in the path
        if exist(zips(k).test,'file') == 0
            % get data
            url = zips(k).url;
            name = zips(k).name;
            % download zip file
            zipname = websave(name,url);
            % create a folder utilizing name as the foldername name
            if ~exist([outputdir,name], 'dir')
                mkdir([outputdir,name]);
            end
            % unzip the zip
            unzip(zipname,[outputdir,name]);
            % delete the zip file
            delete([name,'.zip'])
            % output to the command window
            disp(['Downloaded and unzipped ',name])
        end
    end
end
%-------------------------------------------------------------------------- 
function CheckMatlabIsomorphismFunction
    disp('--- Checking Matlab''s isomorphism function')
    
    % check if isisomorphic is available
    try 
        graph;
        isisomorphic(graph(1,1),graph(1,1));
        disp('isisomorphic is available')
        disp('opts.isomethod = ''Matlab'' is available')
    catch
        disp('opts.isomethod = ''Matlab'' is NOT available X')
        disp('need MATLAB 2016b or newer')
    end
    disp(' ')
end
%--------------------------------------------------------------------------
function PythonSetupCheck
	disp('--- Checking Python setup')
    
    CheckFlag = 0;
    
	% need python
	[version, ~, ~] = pyversion;
    if isempty(version)
	    disp('python is NOT available X')
    else
        CheckFlag = CheckFlag + 1;
	    disp('python is available')
    end
    
	% need numpy
    try
        py.numpy.matrixlib.defmatrix.matrix([]);
        CheckFlag = CheckFlag + 1;
	    disp('numpy  is available')
    catch
	    disp('numpy  is NOT available X')
    end

	% need python_igraph
    try
        py.igraph.Graph;
        CheckFlag = CheckFlag + 1;
	    disp('igraph is available')
    catch
	    disp('igraph is NOT available X')
    end
    
    % if all required python packages are available
    if CheckFlag == 3
        disp('opts.isomethod = ''Python'' is available')
    else
        disp('opts.isomethod = ''Python'' is NOT available X')
        disp('please see https://github.com/danielrherber/pm-architectures-project/blob/master/optional/PythonIsoSetup.md')
    end
    
	disp(' ')
end
%--------------------------------------------------------------------------
function OpenExample
	disp('--- Setup complete, opening an example')
	disp(' ')

	% open case study 1 for md-16-1635
	open ex_md161635_CaseStudy1
end