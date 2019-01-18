%--------------------------------------------------------------------------
% Test_Enhancements.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear
clc
close all
closeallbio

alg1 = 'tree_v1'; % original tree algorithm
alg2 = 'tree_v8'; % with all enhancements

testnum = 3;

opts.displevel = 1; % off
opts.plotmax = 0;
opts.isomethod = 'Python'; % 'Matlab'

switch testnum
    case 1 % best case, only 1 graph
        n = 8;
        P = [2]; % ports vector 
        R = [n]; % replicates vector
        C = {'R'}; % label vector
        NSC.counts = 1;
        NSC.M = 1;
        
    case 2 % worst case, pure pm (n-1)!!
        n = 8;
        P = ones(n,1);
        R = ones(n,1);
        for k = 1:n
            C{k} = num2str(k);
        end
        NSC = [];
        
    case 3 % general problem
       P = [1 2 3];
       R = [4 3 2];
       C = {'R','G','B'};
       NSC = [];
       
    case 4 % general problem with NSCs
        P = [1 2 3];
        R = [4 4 4];
        C = {'R','G','B'};
        A = ones(length(P));
        A(2,1) = 0; % G-R
        A(3,3) = 0; % B-B
        A = round((A+A')/3);
        NSC.A = A;
        NSC.counts = 1;
        NSC.M = [1 1 1];
        
end

% test the first algorithm
opts.algorithm = alg1;
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
n1 = numel(FinalGraphs);

if (opts.displevel > 0) % minimal 
    disp(' ')
end

% test the second algorithm
opts.algorithm = alg2;
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
n2 = numel(FinalGraphs);

disp(' ')
if n1 == n2
    disp('test passed (when comparing lengths of FinalGraphs)')
else
    disp('test failed (when comparing lengths of FinalGraphs)')
end
disp(' ')