%--------------------------------------------------------------------------
% PMA_TEST_Algorithms.m
% Test a bunch of graph generating algorithms for a specified problem
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% list of algorithms
algorithm = {};
% algorithm{end+1} = 'tree_v1';
% algorithm{end+1} = 'tree_v8';
% algorithm{end+1} = 'tree_v10';
% algorithm{end+1} = 'tree_v11DFS';
% algorithm{end+1} = 'tree_v11BFS';
% algorithm{end+1} = 'tree_v1_mex';
% algorithm{end+1} = 'tree_v8_mex';
% algorithm{end+1} = 'tree_v10_mex';
% algorithm{end+1} = 'tree_v11DFS_mex';
% algorithm{end+1} = 'tree_v11BFS_mex';
algorithm{end+1} = 'tree_v1_analysis';
algorithm{end+1} = 'tree_v8_analysis';
algorithm{end+1} = 'tree_v10_analysis';
algorithm{end+1} = 'tree_v11DFS_analysis';
algorithm{end+1} = 'tree_v11BFS_analysis';
algorithm{end+1} = 'tree_v12DFS_analysis';
algorithm{end+1} = 'tree_v12BFS_analysis';

% test number
num = 1;

% problem specification
P = [1 2 3]; % ports vector
R = [3 2 1]; % replicates vector
C = {'R','G','B'}; % label vector

% different modifications to original problem specification
switch num
    case 1 % Case Study 1, #1
        NSC = []; % no constraints
    case 2 % Case Study 1, #2 constraints
        NSC.M = [0 0 1];
        % NSC.M = [1 1 1];
        NSC.simple = 1;
end

% options
opts = currentopts;

% initialize
FinalGraphs = cell(length(algorithm),1);

% go through each algorithm
for idx = 1:length(algorithm)
    %
    opts.algorithm = algorithm{idx};

    % generate graphs
    FinalGraphs{idx} = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

    % display number of graphs
    disp(['Number of unique, feasible graphs using ',algorithm{idx},': ',num2str(length(FinalGraphs{idx}))])
end

% options
function opts = currentopts
    opts.displevel = 0;
    opts.isomethod = 'python'; % option 'Matlab' is available in 2016b or later versions
    opts.plots.plotmax = 0; % maximum number of graphs to display/save
end