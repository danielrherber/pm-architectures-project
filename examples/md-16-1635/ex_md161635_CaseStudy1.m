% this case study replicates the results from Case Study 1:
% JMD paper MD-16-1635
% FIGURE 10: All 16 unique graphs with no additional NSCs for Case Study 1.

clear
clc
close all
closeallbio

% test number
num = 1; 

switch num
    case 1
        P = [1 2 3]; % ports vector 
        R = [3 2 1]; % replicates vector
        C = {'R','G','B'}; % label vector
        NSC = []; % no constraints

    case 2
        P = [1 2 3]'; % ports vector 
        R = [3 2 1]'; % replicates vector
        C = {'R','G','B'}; % label vector
        % Case Study 1, #2 constraints
        NSC.M = [0 0 1];
        % NSC.M = [1 1 1];
        NSC.counts = 1;
end

% options
opts.algorithm = 'tree_v1';
opts.Nmax = 1e7; % maximum number of graphs to preallocate for
opts.parallel = 0; % 0 to disable parallel computing, otherwise max number of workers
opts.filterflag = 1; % 1 is on, 0 is off
% opts.customfun = @(pp,A,infeasibleFlag) ex_Example1_Extra_Constraints(pp,A,infeasibleFlag);
opts.plotfun = 'circle'; % 'circle' % 'bgl' % 'bio' % 'matlab'
% opts.plotmax = Inf; % maximum number of graphs to display/save
opts.plotmax = 100;
opts.saveflag = 0; % save graphs to disk
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to
opts.isomethod = 'Matlab'; % option 'Matlab' is available in 2016b or later versions

FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);