%--------------------------------------------------------------------------
% PMA_EX_MD161635_CS2.m
% This example replicates the results from Case Study 2 in the paper below
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017; 139(5):051403. doi:10.1115/1.4036132
% FIGURE 12: All 12 unique graphs for Case Study 2 requiring all components
% to be connected and a specified number of unique edges.
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test number
num = 1;

% use the newer algorithm with enhancements? see tech. report on README
newalgo = 0; % 0:no, 1:yes

% problem specification
P = [1 1 2 3 4]; % ports vector
R = [1 2 2 1 1]; % replicates vector
C = {'P','R', 'G', 'B', 'O'}; % label vector

% different modifications to original problem specification
switch num
    case 1 % Case Study 2, #1 constraints
        NSC.M = [0 0 0 0 0];
    case 2 % Case Study 2, #2 constraints
        NSC.M = [1 0 0 0 0];
    case 3 % Case Study 2, #3 constraints
        NSC.M = [1 1 1 1 1];
        NSC.simple = 1; % no multiedges
        NSC.connected = 1; % connected graph
        NSC.loops = 0; % no loops
    case 4 % Case Study 2, #4 constraints
        if newalgo % new
            clear R % remove previous
            R.min = [1 2 1 1 1]; % replicates vector, min
            R.max = [1 2 2 1 1]; % replicates vector, max
            NSC.connected = 1; % connected graph
            NSC.loops = 0; % no loops
        else % old
            P = [1 1 2 2 3 4]; % ports vector
            R = [1 2 1 1 1 1]; % replicates vector
            C = {'P','R', 'G', 'G', 'B', 'O'}; % label vector
            NSC.M = [1 1 1 0 1 1];
            NSC.loops = 0; % no loops
        end
        NSC.simple = 1; % no multiedges
end

% options
if newalgo
    opts.algorithm = 'tree_v12DFS'; % new
else
    opts.algorithm = 'tree_v1'; % old
end
opts.algorithms.Nmax = 1e5; % maximum number of graphs to preallocate for
opts.parallel = false; % 12 threads for parallel computing, 0 to disable it
opts.filterflag = 1; % 1 is on, 0 is off
opts.isomethod = 'matlab'; % option 'Matlab' is available in 2016b or later versions
opts.plots.plotfun = 'matlab'; % 'circle' % 'bgl' % 'bio' % 'matlab'
opts.plots.plotmax = 20; % maximum number of graphs to display/save
opts.plots.name = mfilename; % name of the example
opts.plots.path = mfoldername(mfilename('fullpath'),[opts.plots.name,'_figs']); % path to save figures to
opts.plots.labelnumflag = 0; % add replicate numbers when plotting
opts.plots.colorlib = @CustomColorLib;

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% custom label color function
function c = CustomColorLib(L)
c = zeros(length(L),3); % initialize
for k = 1:length(L) % go through each label and assign a color
    if contains(L(k,:),'R')
        ct = [244,67,54]; % red 500
    elseif contains(L(k,:),'G')
        ct = [139,195,74]; % lightGreen 500
    elseif contains(L(k,:),'B')
        ct = [3,169,244]; % lightBlue 500
    elseif contains(L(k,:),'O')
        ct = [255,152,0]; % orange 500
    elseif contains(L(k,:),'P')
        ct = [156,39,176]; % purple 500
    else
        ct = [0 0 0 ];
    end
    c(k,:) = ct/255; % assign
end
end