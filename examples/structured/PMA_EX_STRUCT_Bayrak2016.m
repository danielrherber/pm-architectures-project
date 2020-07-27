%--------------------------------------------------------------------------
% PMA_EX_STRUCT_Bayrak2016.m
% Example based on the reference below for generating different hybrid
% powertrain architectures
%--------------------------------------------------------------------------
% Bayrak A, Ren Y, Papalambros PY. Topology Generation for Hybrid Electric
% Vehicle Architecture Design. ASME. J. Mech. Des. 2016; 138(8):081401.
% doi:10.1115/1.4033656.
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% M <-> Motor
% E <-> Engine
% V <-> Vehicle
% G <-> Ground
% P <-> Planetary Gear
% A <-> Three Port Connection
% B <-> Four Port Connection
C = {'M','E','V','G','P','A','B'}; % label vector
P = [1 1 1 1 3 3 4]; % ports vector

% test number
num = 1;

% different modifications to original problem specification
switch num
    %----------------------------------------------------------------------
    case 1 % one planetary gear
    R.min = [1 0 1 0 1 0 0];
    R.max = [2 1 1 1 1 1 1];
    %----------------------------------------------------------------------
    case 2 % one or two planetary gears
    R.min = [1 0 1 0 2 0 0];
    R.max = [2 1 1 1 2 1 1];
    %----------------------------------------------------------------------
end

% network structure constraints
NSC.simple = 1; % unique edges
NSC.loops = 0; % no loops
NSC.connected = 1; % connected graph
NSC.directA = ones(length(P)); % limit connections, initialize
NSC.directA(6,6) = 0; % no A-A
NSC.directA(7,7) = 0; % no B-B
NSC.directA(7,6) = 0; % no B-A
NSC.S = [0 0 0 0 1 0 0]; % structured components

% structured-specific options
opts.structured.isotree = 'AIO'; % AIO (all-in-one) or LOE (level-order)
opts.structured.ordering = 'none'; % RA

% general options
opts.plots.plotmax = 10;
opts.plots.randomize = true; % randomized ordering
opts.plots.labelnumflag = false;
opts.plots.colorlib = @CustomColorLib;
opts.isomethod = 'py-igraph'; % labeled graph isomorphism checking method
opts.parallel = true; % no parallel computing

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);

% custom color library
function c = CustomColorLib(L)
c = zeros(length(L),3); % initialize
for k = 1:length(L) % go through each label and assign a color
    switch upper(L{k}(1))
        case 'M'
            ct = [33,150,243]/255; % blue material
        case 'E'
            ct = [255,193,7]/255; % amber material
        case 'V'
            ct = [76,175,80]/255; % green material
        case 'G'
            ct = [121,85,72]/255; % brown material
        case 'P'
            ct = [233,30,99]/255; % pink material
        case 'A'
            ct = [96,125,139]/255; % blue gray material
        case 'B'
            ct = [156,39,176]/255; % purple material
    end
    c(k,:) = ct; % assign
end
end