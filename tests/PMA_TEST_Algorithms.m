%--------------------------------------------------------------------------
% PMAex_md161635_caseStudy1.m
% This example replicates the results from Case Study 1 in the paper below
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017; 139(5):051403. doi:10.1115/1.4036132
% FIGURE 10: All 16 unique graphs with no additional NSCs for Case Study 1.
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% list of algorithms
algorithm = {};
algorithm{end+1} = 'tree_v1';
algorithm{end+1} = 'tree_v8';
algorithm{end+1} = 'tree_v10';
algorithm{end+1} = 'tree_v11DFS';
algorithm{end+1} = 'tree_v11BFS';
algorithm{end+1} = 'tree_v1_mex';
algorithm{end+1} = 'tree_v8_mex';
algorithm{end+1} = 'tree_v10_mex';
algorithm{end+1} = 'tree_v11DFS_mex';
algorithm{end+1} = 'tree_v11BFS_mex';

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
        NSC.counts = 1;
end

% options
opts = currentopts;

% initialize
FinalGraphs = cell(length(algorithm),1);

% go through each algorith
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