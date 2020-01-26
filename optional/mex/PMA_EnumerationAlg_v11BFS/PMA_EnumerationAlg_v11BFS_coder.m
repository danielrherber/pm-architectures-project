%--------------------------------------------------------------------------
% PMA_EnumerationAlg_v11BFS_coder.m
% Generate MEX-function for PMA_EnumerationAlg_v11BFS
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
% files
org_name = 'PMA_EnumerationAlg_v11BFS'; % function that should be mexed
mex_name = 'PMA_EnumerationAlg_v11BFS_mex'; % mex function name
test_name = 'PMA_EnumerationAlg_v11BFS_test'; % test function

% check if the file is available and runs
try
   eval(test_name)
   disp([mex_name,' already exists'])
   return
catch
   disp(['creating ',mex_name])
end

% number of output arguments
noutputs = 1;

% define argument types for entry-point function
ARGS = cell(1,1);
ARGS{1} = cell(17,1);
ARGS{1}{1} = coder.typeof(uint8(0),[1 Inf],[0 1]); % cVf
ARGS{1}{2} = coder.typeof(uint8(0),[1 Inf],[0 1]); % Vf
ARGS{1}{3} = coder.typeof(uint8(0),[Inf 1],[1 0]); % iInitRep
ARGS{1}{4} = coder.typeof(uint16(0),[1 Inf],[0 1]); % phi
ARGS{1}{5} = coder.typeof(uint8(0),[1 Inf],[0 1]); % counts
ARGS{1}{6} = coder.typeof(uint8(0),[Inf Inf],[1 1]); % A
ARGS{1}{7} = coder.typeof(false); % Bflag
ARGS{1}{8} = coder.typeof(uint8(0),[Inf Inf Inf],[1 1 1]); % B
ARGS{1}{9} = coder.typeof(false); % Mflag
ARGS{1}{10} = coder.typeof(uint8(0),[1 Inf],[0 1]); % M
ARGS{1}{11} = coder.typeof(false); % Pflag
ARGS{1}{12} = coder.typeof(false); % Iflag
ARGS{1}{13} = coder.typeof(uint8(0)); % Imethod
ARGS{1}{14} = coder.typeof(uint64(0)); % IN
ARGS{1}{15} = coder.typeof(double(0),[1 Inf],[0 1]); % Ln
ARGS{1}{16} = coder.typeof(uint64(0)); % Nmax
ARGS{1}{17} = coder.typeof(uint8(0)); % displevel

% directories
oldfolder = pwd; % get current directory
mexfolder = mfoldername(mfilename('fullpath'),''); % mex folder
tempfolder = getenv('TEMP'); % get temp folder

% create configuration object of class coder.MexCodeConfig
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;

% change to project directory
cd(tempfolder);

% invoke MATLAB Coder
str = ['codegen -config cfg -o ',mex_name,' ',org_name,...
    ' -args ARGS{1} -nargout ',num2str(noutputs)];
eval(str)

% copy the mex file from the temp directory
source = fullfile(tempfolder,[mex_name,'.',mexext]);
copyfile(source,mexfolder,'f')

% change back to original directory
cd(oldfolder)

% run test function
eval(test_name)