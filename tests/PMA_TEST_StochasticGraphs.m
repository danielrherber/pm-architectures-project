%--------------------------------------------------------------------------
% PMA_TEST_StochasticGraphs.m
% Script to explore the properties of the different stochastic generators
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% define problem and options (see function below)
[L,R,P,NSC,opts] = problem;

% generate graphs (only unique graphs in G0)
opts.isomethod = 'py-igraph';
opts.algorithm = 'tree_v1';
G0 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

disp(strcat("number of unique graphs: ",string(length(G0))))

% generate random graphs (potentially isomorphic graphs in G1)
opts.isomethod = 'none';
opts.algorithm = 'tree_v1_stochastic';
% opts.algorithm = 'tree_v8_stochastic';
opts.algorithms.Nmax = 1000; % number of graphs to generate
opts.filterflag = false; % turn off filtering to return all graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

disp(strcat("number of generated graphs: ",string(length(G1))))

% combine unique graph set with randomly generated graph set
G2 = [G0,G1];

% set isomorphism checking option
opts.isomethod = 'py-igraph';

% determine the set of nonisomorphic graphs
[G3,isoGraphIdx] = PMA_RemoveIsoLabeledGraphs(G2,opts);

% plot initialization
hf = figure; hold on; hf.Color = 'w';

% bin graphs by uniqueness
[N,edges] = histcounts(isoGraphIdx,'BinMethod','integers');

% find graphs that were not found through random generation
Imissing = N==1;
N(Imissing) = 0;

disp(strcat("number of missing graphs: ",string(sum(Imissing))))

% plot
hb = bar(1:(edges(end)-0.5),N-1,'FaceColor','flat');
ylim([-1,max(N)])
xlabel("Unique Graph Index")
ylabel("Number of Occurrences")

% change color for missing graphs
missingColor = [1 0 0];
hb.CData(Imissing,:) = repmat(missingColor,sum(Imissing),1);

return

% problem and options
function [L,R,P,NSC,opts] = problem

num = 1;

% problem specification
P = [1 1 2 3 4]; % ports vector
R = [1 2 2 1 1]; % replicates vector
L = {'P','R', 'G', 'B', 'O'}; % label vector

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
            L = {'P','R', 'G', 'G', 'B', 'O'}; % label vector
            NSC.M = [1 1 1 0 1 1];
        end
        NSC.simple = 1; % no multiedges
end

% options
opts.displevel = 0;
opts.parallel = false; % 12 threads for parallel computing, 0 to disable it
opts.plots.plotfun = 'matlab'; % 'circle' % 'bgl' % 'bio' % 'matlab'
opts.plots.plotmax = 0; % maximum number of graphs to display/save
opts.plots.labelnumflag = 0; % add replicate numbers when plotting

end