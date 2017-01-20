% this case study replicates the results from Case Study 2:
% http://systemdesign.illinois.edu/publications/Her16b.pdf
% FIGURE 12: All 12 unique graphs for Case Study 2 requiring all components 
% to be connected and a specified number of unique edges.

clear
clc
close all
closeallbio

% test number
num = 3; 

switch num
    case 1
        P = [1 1 2 3 4]'; % ports vector
        R = [1 2 2 1 1]'; % replicates vector
        C = {'P','R', 'G', 'B', 'O'}; % label vector     
        % Case Study 2, #1 constraints
        NSC.necessary = [0 0 0 0 0];
        NSC.counts = 0;
        NSC.self = 1; % allow self-loops
        NSC.A = ones(length(P)); % provide potential adjacency matrix
        
    case 2
        P = [1 1 2 3 4]'; % ports vector
        R = [1 2 2 1 1]'; % replicates vector
        C = {'P','R', 'G', 'B', 'O'}; % label vector
        % Case Study 2, #2 constraints
        NSC.necessary = [1 0 0 0 0];
        NSC.counts = 0;
        NSC.self = 1; % self-loops
        NSC.A = ones(length(P)); % provide potential adjacency matrix
        
    case 3
        P = [1 1 2 3 4]'; % ports vector
        R = [1 2 2 1 1]'; % replicates vector
        C = {'P','R', 'G', 'B', 'O'}; % label vector
        % Case Study 2, #3 constraints
        NSC.necessary = [1 1 1 1 1];       
        NSC.counts = 1;
        NSC.self = 0; % self-loops
        NSC.A = ones(length(P)); % provide potential adjacency matrix
        
    case 4
        P = [1 1 2 2 3 4]'; % ports vector
        R = [1 2 1 1 1 1]'; % replicates vector
        C = {'P','R', 'G', 'G', 'B', 'O'}; % label vector
        % Case Study 2, #4 constraints
        NSC.necessary = [1 1 1 0 1 1];
        NSC.counts = 1;
        NSC.self = 0; % self-loops
        NSC.A = ones(length(P)); % provide potential adjacency matrix   

end

% options
opts.algorithm = 'tree_v1'; %
[P,R,C,NSC] = ReorderCRP(P,R,C,NSC,opts);
opts.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.parallel = 0; % 0 to disable parallel computing, otherwise max number of workers
opts.portisofilter = 1; % 1 is on, 0 is off
% opts.customfun = @(pp,A,infeasibleFlag) ex_Example2_Extra_Constraints(pp,A,infeasibleFlag);
opts.plotfun = 'bgl'; % 'circle' % 'bgl' % 'bio'
opts.plotmax = 0; % maximum number of graphs to display/save
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to
opts.isomethod = 'Matlab'; % option 'Matlab' is available in 2016b or later versions

FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);