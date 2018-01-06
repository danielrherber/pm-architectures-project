%--------------------------------------------------------------------------
% ex_Structured_Example1.m
% Simple example with some structured components
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli, Undergraduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% problem specifications
P = [1 2 3]; % ports vector 
R = [3 2 1]; % replicates vector
C = {'R','G','B'}; % label vector

% test number
num = 4; 

% different modifications to original problem specification
switch num
    case 1
        NSC.S = [0,0,1]; % structured components
    case 2
        NSC.S = [0,1,0]; % structured components
    case 3
        NSC.S = [0,1,1]; % structured components
    case 4
        NSC.M = [0,0,1]; % mandatory components
        NSC.counts = 1; % all connections must be unique
        NSC.S = [0,0,1]; % structured components
end
% structured-specific options
opts.structured.isotree = 'AIO'; % AIO (all-in-one) or LOE (level-order)
opts.structured.ordering = 'none'; % RA
    
% general options
opts.parallel = 0; % 0 to disable parallel computing, otherwise max number of workers
opts.plotfun = 'circle'; % 'circle' % 'bgl' % 'matlab'
opts.plotmax = 100;
opts.saveflag = 0; % save graphs to disk
opts.name = mfilename; % name of the example
opts.path = mfoldername(mfilename('fullpath'),[opts.name,'_figs']); % path to save figures to
opts.isomethod = 'Matlab'; % option 'Matlab' is available in 2016b or later versions

% generate graphs
FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);