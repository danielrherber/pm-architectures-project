%--------------------------------------------------------------------------
% PMA_TEST_STRUCT_MethodComparison.m
% Comparison between AIO, LOE with no simple checks, and LOE with simple
% checks
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on Github
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
close all; clear; clc

% testing options
example = 2; % see PMA_STRUCT_ExampleSimpleGraphs
methods = {'Normal Checks','LOE Normal','LOE Simple'}; % methods to test
% methods{1} = methods{3};
% methods{1} = 'LOE Simple';
nTests = 1; % number of times to repeat the tests
saveFlag = 1; % save the results?

% options
opts.structured.parallel = 0; % no parallel computing
opts.isomethod = 'python'; % matlab isomorphism checking option
opts = PMA_DefaultOpts(opts); % default options
origdir = PMA_Change2PythonFolder(opts,true,[]);

% obtain the simple graphs for the selected example
[C,R,P,S,FinalGraphs] = PMA_TEST_STRUCT_ExampleSimpleGraphs(example,opts);

%--------------------------------------------------------------------------
% Run the tests
%--------------------------------------------------------------------------
% initialize
O = cell(nTests,length(methods));
T = zeros(nTests,length(methods));

% repeat the tests
for idx = 1:nTests

    % go through each method
    for k = 1:length(methods)

        % get the method options
        switch methods{k}
            case 'Normal Checks'
                opts.structured.simplecheck = 0;
                opts.structured.isotree = 'AIO';
            case 'LOE Normal'
                opts.structured.simplecheck = 0;
                opts.structured.isotree = 'LOE';
            case 'LOE Simple'
                opts.structured.simplecheck = 1;
                opts.structured.isotree = 'LOE';
        end

        % start timer
        t1 = tic;

        % initialize output structure
        Output = cell(length(FinalGraphs),1);

        % expand each simple graph
        for j = 1:length(FinalGraphs)

            % output to command window
            message = ['Iter ',num2str(idx),' on Graph ',num2str(j),...
                ' using ',methods{k},' and ',opts.structured.isomethod,...
                ' iso checking'];
            disp(message)

            % expand a single simple graph
            Output{j} = PMA_STRUCT_Sort(C,P,S,opts,FinalGraphs(j));

        end

        % save the structured graphs
        O{idx,k} = horzcat(Output{:});

        % record the computation time
        T(idx,k) = toc(t1);

    end

    % calculate the measure for central tendency and spread
    Average = mean(T);
    Std = std(T);

end

%--------------------------------------------------------------------------
% Save the results
%--------------------------------------------------------------------------
if saveFlag && nTests >= 30

    % use only the later tests
    T = T(11:end,:);

    % construct file name
    filepath = mfoldername(mfilename('fullpath'),'output');
    filename = ['Times_SimpleCheck_Method(',opts.structured.isomethod,')_'...
        ,num2str(nTests),'_LoopsOn_Example',num2str(example),'.mat'];
    fullname = fullfile(filepath,filename);

    % save the results
    save(fullname,'methods','T','Average','Std');

end