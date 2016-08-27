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
function PythonSetupCheck
	disp('--- Checking Python setup')
	disp(' ')

	% need Python 3.5
	[version, ~, ~] = pyversion;
	if isempty(version)
	    disp('Download Python 3.5 from https://www.python.org/downloads')
	    disp('Be sure to download the correct 32-bit or 64-bit executable installer compatible with your MATLAB configuration.')
	    disp('Check "Add Python 3.5 to PATH"')
	    disp('Check "Precompile standard library"')
	    disp('Also see http://www.mathworks.com/help/matlab/matlab_external/system-and-configuration-requirements.html')
	    disp('Python 2.7 has also worked but 3.5 is the supported version')
	    disp('Press any key when you are done installing Python')
	    disp(' ')
	    pause
	end

	% need numpy
	try
	    py.numpy.matrixlib.defmatrix.matrix([]);
	catch
	    disp('Download package numpy from http://www.lfd.uci.edu/~gohlke/pythonlibs/#numpy')
	    disp('Recommend numpy-1.11.1+mkl-cp35-cp35m-win_amd64.whl for 64-bit MATLAB configuration and Python 3.5')
	    disp('Installation of numpy requires pip, try running pip in cmd')
	    disp('You may need to open cmd at C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python35\Scripts')
	    disp('Run the command (assuming the same version as above): pip install %LOCATION%\numpy-1.11.1+mkl-cp35-cp35m-win_amd64.whl')
	    disp('See http://stackoverflow.com/questions/27885397 for more info on installing .whl with pip')
	    disp('Press any key when you are done installing numpy')
	    disp(' ')
	    pause
	end
	% try again, errors occurs if numpy is unavailable
	py.numpy.matrixlib.defmatrix.matrix([]);

	% need python_igraph
	try
	    py.igraph.Graph;
	catch
	    disp('Download package python_igraph from http://www.lfd.uci.edu/~gohlke/pythonlibs/#python-igraph')
	    disp('Recommend python_igraph-0.7.1.post6-cp35-none-win_amd64.whl for 64-bit MATLAB configuration and Python 3.5')
	    disp('Installation of numpy requires pip, try running pip in cmd')
	    disp('You may need to open cmd at C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python35\Scripts')
	    disp('Run the command (assuming the same version as above): pip install %LOCATION%\python_igraph-0.7.1.post6-cp35-none-win_amd64.whl')
	    disp('See http://stackoverflow.com/questions/27885397 for more info on installing .whl with pip')
	    disp('Press any key when you are done installing python_igraph')
	    disp(' ')
	    pause
	end
	% try again, errors occurs if python_igraph is unavailable
	py.igraph.Graph;
end
%--------------------------------------------------------------------------
function OpenExample
	disp('--- Setup complete, opening an example')
	disp(' ')

	% open case study 1
	open ex_CaseStudy1
end