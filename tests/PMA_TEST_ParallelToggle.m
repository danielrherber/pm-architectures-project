%--------------------------------------------------------------------------
% PMA_TEST_ParallelToggle.m
% Tests for the function PMA_ParallelToggle
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% tests to run
% tests = [0 1 2 3 4 0 1]; % only single input
tests = [1 6 8 10]; % delete then start using second inputs
% tests = [2 0 5 7 9]; % start 1 pool and then do nothing

% run through the tests
for test = tests(:)'

    % different tests
    switch test
        case 0
            PMA_ParallelToggle('')
        case 1
            PMA_ParallelToggle('delete')
        case 2
            PMA_ParallelToggle('start')
        case 3
            PMA_ParallelToggle('start-spmd')
        case 4
            PMA_ParallelToggle('start-py')
        case 5
            PMA_ParallelToggle('start',false)
        case 6
            PMA_ParallelToggle('start',true)
        case 7
            PMA_ParallelToggle('start',0)
        case 8
            PMA_ParallelToggle('start',5)
        case 9
            in.parallel = 0;
            PMA_ParallelToggle('start',in)
        case 10
            in.parallel = 3;
            PMA_ParallelToggle('start',in)
        otherwise
            disp("test not defined")
    end

    % display to command window
    disp(string(test))
    disp(gcp('nocreate'))

end