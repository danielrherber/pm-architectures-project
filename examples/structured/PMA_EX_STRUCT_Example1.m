%--------------------------------------------------------------------------
% PMA_EX_STRUCT_Example1.m
% Simple example with some structured components
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% problem specifications
P = [1 2 3]; % ports vector
R.min = [3 2 1]; R.max = [3 2 1]; % replicates vector
C = {'R','G','B'}; % label vector

% test number
num = 4;

% different modifications to original problem specification
switch num
    %----------------------------------------------------------------------
    case 1 % one 3-port structured components (44 graphs)
    NSC.S = [0,0,1]; % structured components
    %----------------------------------------------------------------------
    case 2 % two 2-port structured components (34 graphs)
    NSC.S = [0,1,0]; % structured components
    %----------------------------------------------------------------------
    case 3 % both 2 and 3-port structured components (144 graphs)
    NSC.S = [0,1,1]; % structured components
    %----------------------------------------------------------------------
    case 4 % only some mandatory components, simple graph (16 graphs)
    R.min = [0 0 1]; R.max = [3 2 1]; % replicates vector
    NSC.loops = 0; % no loops allowed
    NSC.simple = 1; % all connections must be unique
    NSC.S = [0,0,1]; % structured components
    %----------------------------------------------------------------------
end

% structured-specific options
opts.structured.isotree = 'AIO'; % AIO (all-in-one) or LOE (level-order)
opts.structured.ordering = 'none'; % RA

% general options
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.isomethod = 'py-igraph'; % labeled graph isomorphism checking method
opts.parallel = false; % no parallel computing

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);