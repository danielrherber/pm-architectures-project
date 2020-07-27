%--------------------------------------------------------------------------
% PMA_TEST_STRUCT_OrderingAnalysis.m
% Test the different sorting options
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
close all; clear; clc

% testing options
example = 1; % see PMA_STRUCT_ExampleSimpleGraphs
methods = {'None','TA','TD','RA','RD','PA','PD'};  % methods to test
nTests = 2; % number of times to repeat the tests
saveFlag = 1; % save the results?
TestIndices = nan; % indices to test, use nan to test all
% TestIndices = 1:5; % indices to test, use nan to test all

% options
opts.structured.parallel = 0; % no parallel computing
opts.isomethod = 'python'; % matlab isomorphism checking option
opts = PMA_DefaultOpts(opts); % default options

% obtain the simple graphs for the selected example
[L,R,P,S,FinalGraphs] = PMA_TEST_STRUCT_ExampleSimpleGraphs(example,opts);

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
        opts.structured.ordering = methods{k};

        % start timer
        t1 = tic;

        % determine the indices to test
        if isnan(TestIndices)
            I = 1:length(FinalGraphs);
        else
            I = TestIndices;
        end

        % initialize output structure
        Output = cell(length(I),1);

        % expand each simple graph
        for j = I

            % output to command window
            message = ['Iter ',num2str(idx),' on Graph ',num2str(j),...
                ' using ',methods{k}];
            disp(message)

            % expand a single simple graph
            Output{j} = PMA_STRUCT_Sort(L,P,S,opts,FinalGraphs(j));

        end

        % save the structured graphs
        O{idx,k} = horzcat(Output{:});

        % record the computation time
        T(idx,k) = toc(t1);

    end
end

% calculate the measure for central tendency and spread
Average = mean(T);
Std = std(T);

%--------------------------------------------------------------------------
% Save the results
%--------------------------------------------------------------------------
% potentially save the results
if saveFlag && nTests >= 30

    % use only the later tests
    T = T(11:end,:);

    % construct file name
    filepath = mfoldername(mfilename('fullpath'),'output');
    filename = ['Times_Ordering_',num2str(nTests-10),'.mat'];
    fullname = fullfile(filepath,filename);

    % save the results
    save(fullname,'methods','T','Average','Std');

end