%--------------------------------------------------------------------------
% PMA_EX_MD161635_CS1.m
% This example replicates the results from Case Study 1 in the paper below
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017; 139(5):051403. doi:10.1115/1.4036132
% FIGURE 10: All 16 unique graphs with no additional NSCs for Case Study 1.
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
        NSC.simple = 1; % no multiedges
        NSC.loops = 0; % no loops
        NSC.connected = 1; % connected graph
end

% options
if newalgo
    opts.algorithm = 'tree_v8'; % new
else
    opts.algorithm = 'tree_v1'; % old
end
opts.algorithms.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.parallel = 0; % 12 threads for parallel computing, 0 to disable it
opts.filterflag = 1; % 1 is on, 0 is off
opts.isomethod = 'matlab'; % option 'Matlab' is available in 2016b or later versions

opts.plots.plotfun = 'circle'; % 'circle' % 'bgl' % 'bio' % 'matlab'
opts.plots.plotmax = 100; % maximum number of graphs to display/save
opts.plots.saveflag = false; % save graphs to disk
opts.plots.name = mfilename; % name of the example
opts.plots.path = mfoldername(mfilename('fullpath'),[opts.plots.name,'_figs']); % path to save figures to
opts.plots.outputtype = 'png'; % 'pdf'
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
    end
    c(k,:) = ct/255; % assign
end
end