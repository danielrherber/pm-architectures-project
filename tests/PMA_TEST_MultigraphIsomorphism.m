%--------------------------------------------------------------------------
% PMA_TEST_MultigraphIsomorphism.m
% Test for labeled multigraph isomorphism issues
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

isomethod = 3;
switch isomethod
    case 1
        isomethod = 'matlab';
    case 2
        isomethod = 'py-networkx';
    case 3
        isomethod = 'py-igraph';
end

% graph specification
L = {'A','B','C','D'};
A = zeros(4); A(1,2) = 2; A(1,4) = 1; A(2,3) = 1; A(3,4) = 2;
A = A + A';

% generate all permutations
P = perms(1:4);

% create permuted graphs
for idx = 1:size(P,1)
    G(idx).L = L(P(idx,:));
    G(idx).Ln = base2dec(G(idx).L,36)';
end

% assign
[G(:).A] = deal(A);
[G(:).N] = deal(0);

% required options for PMA_RemoveIsoLabeledGraphs
opts = currentopts(isomethod);
NSC.connected = 1;

% plot original graphs
% PMA_PlotGraphs(G,NSC,opts)

% check for labeled multigraph isomorphisms
UG = PMA_RemoveIsoLabeledGraphs(G,opts);

% plot "unique" graphs
% PMA_PlotGraphs(UG,NSC,opts)

% UG should be 6
disp("correct:")
disp(string(isequal(length(UG),6)))
disp(string(length(UG)))

% options
function opts = currentopts(isomethod)
    opts = PMA_DefaultOpts;
    opts.displevel = 0;
    opts.isomethod = isomethod;
    opts.plots.plotmax = inf; % maximum number of graphs to display/save
    PMA_Change2PythonFolder(opts,true,[]); % change to python folder
end