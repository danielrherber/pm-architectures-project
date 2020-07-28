%--------------------------------------------------------------------------
% PMA_TEST_ConsistentLabelOrdering.m
% If the initial label ordering is maintained and the set of graphs are
% identical between to similar problems
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% options
opts.algorithm = 'tree_v8_mex';
opts.isomethod = 'py-igraph';
opts.plots.plotmax = 0;
opts.displevel = 2;

disp('all numbers between the versions of the problem should be the same'); disp(' ');

%% test 1 (example 1 from examples folder)
clear NSC C1 R1 P1 C2 R2 P2

I = [3 1 2]; % sorting indices

C1 = {'R','G','B'};
R1 = [3 2 1];
P1 = [1 2 3];

C2 = C1(I);
R2 = R1(I);
P2 = P1(I);

NSC = []; % no constraints

% run sorted
Graphs2 = PMA_UniqueFeasibleGraphs(C2,R2,P2,NSC,opts); disp(' ');

% run unsorted
Graphs1 = PMA_UniqueFeasibleGraphs(C1,R1,P1,NSC,opts); disp(' ');

% find the unique set of graphs
FinalGraphs = PMA_RemoveIsoLabeledGraphs([Graphs2,Graphs1],opts); disp(' ');

if length(Graphs2) == length(FinalGraphs)
    disp(Graphs1(1).L)
    disp(Graphs2(1).L)
    disp('test 1 passed'); disp(' ');
else
    disp('test 1 failed'); disp(' ');
end

%% test 2
clear NSC C1 R1 P1 C2 R2 P2

I = [2 1 3]; % sorting indices

C1 = {'A','B','C'};
R1 = [2 2 2];
P1 = [3 2 3];

C2 = C1(I);
R2 = R1(I);
P2 = P1(I);

NSC.M = ones(1,length(C1));
NSC.simple = 1;

% run sorted
Graphs2 = PMA_UniqueFeasibleGraphs(C2,R2,P2,NSC,opts); disp(' ');

% run unsorted
Graphs1 = PMA_UniqueFeasibleGraphs(C1,R1,P1,NSC,opts); disp(' ');

% find the unique set of graphs
FinalGraphs = PMA_RemoveIsoLabeledGraphs([Graphs2,Graphs1],opts); disp(' ');

if length(Graphs2) == length(FinalGraphs)
    disp(Graphs1(1).L)
    disp(Graphs2(1).L)
    disp('test 2 passed'); disp(' ');
else
    disp('test 2 failed'); disp(' ');
end

%% test 3
clear NSC C1 R1 P1 C2 R2 P2

I = [2 1 3]; % sorting indices

C1 = {'A','B','C'};
R1.min = [1 0 0];
R1.max = [2 2 2];
P1 = [3 2 3];

C2 = C1(I);
R2.min = R1.min(I);
R2.max = R1.max(I);
P2 = P1(I);

NSC.simple = 1;

% run sorted
Graphs2 = PMA_UniqueFeasibleGraphs(C2,R2,P2,NSC,opts); disp(' ');

% run unsorted
Graphs1 = PMA_UniqueFeasibleGraphs(C1,R1,P1,NSC,opts); disp(' ');

% find the unique set of graphs
FinalGraphs = PMA_RemoveIsoLabeledGraphs([Graphs2,Graphs1],opts); disp(' ');

if length(Graphs2) == length(FinalGraphs)
    disp(Graphs1(4).L)
    disp(Graphs2(4).L)
    disp('test 3 passed'); disp(' ');
else
    disp('test 3 failed'); disp(' ');
end