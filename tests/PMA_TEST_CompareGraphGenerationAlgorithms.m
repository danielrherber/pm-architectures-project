%--------------------------------------------------------------------------
% PMA_TEST_CompareGraphGenerationAlgorithms.m
% Compares the number of unique, feasible graphs generated using
% two different generation methods
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

testnum = 3; % test number (see below)
alg1 = 'pm_full'; % first algorithm
alg2 = 'tree_v1'; % second algorithm

opts.isomethod = 'python'; % 'matlab'
opts.displevel = 1; % display level
opts.plotmax = 5; % number of graphs to plot

switch testnum
    case 1 % best case, only 1 graph
        n = 8;
        P = 2; % ports vector
        R = n; % replicates vector
        L = {'R'}; % label vector
        NSC.simple = 1;
        NSC.connected = 1;

    case 2 % worst case, pure pm (n-1)!!
        n = 10;
        P = ones(n,1);
        R = ones(n,1);
        L = string(dec2base((1:n)+9,36));
        NSC = [];

    case 3 % general problem
       P = [1 2 3];
       R = [4 3 2];
       L = {'R','G','B'};
       NSC = [];

    case 4 % general problem with NSCs
        P = [1 2 3];
        R = [2 2 2];
        L = {'R','G','B'};
        A = ones(length(P));
        A(2,1) = 0; % G-R
        A(3,3) = 0; % B-B
        A = round((A+A')/3);
        NSC.directA = A;
        NSC.simple = 1; % simple components
        NSC.connected = 1; % connected graph
        % currently pm_full does not work because Ar check not implemented

end

% test the first algorithm
opts.algorithm = alg1;
FinalGraphs = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);
n1 = numel(FinalGraphs);

if (opts.displevel > 0) % minimal
    disp(' ')
end

% test the second algorithm
opts.algorithm = alg2;
FinalGraphs = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);
n2 = numel(FinalGraphs);

disp(' ')
if n1 == n2
    disp('test passed (when comparing lengths of FinalGraphs)')
else
    disp('test failed (when comparing lengths of FinalGraphs)')
end
disp(' ')