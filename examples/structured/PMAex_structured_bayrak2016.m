%--------------------------------------------------------------------------
% PMAex_structured_bayrak2016.m
% Example based on the reference below for generating different hybrid
% powertrain architectures
%--------------------------------------------------------------------------
% Bayrak A, Ren Y, Papalambros PY. Topology Generation for Hybrid Electric
% Vehicle Architecture Design. ASME. J. Mech. Des. 2016; 138(8):081401.
% doi:10.1115/1.4033656.
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
% Additional Contributor: Shangtingli, Undergraduate Student, UIUC
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
NSC.simple = 1; % unique edges
NSC.connected = 1;
NSC.directA = ones(length(P)); % limit connections, initialize
NSC.directA(6,6) = 0; % no A-A
NSC.directA(7,7) = 0; % no B-B
NSC.directA(7,6) = 0; % no B-A
NSC.S = [0 0 0 0 1 0 0]; % structured components

% test number
num = 2;

% different modifications to original problem specification
switch num
    case 1
        % one planetary gear
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 1 1 1]';
    case 2
        % one or two planetary gears
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 2 1 1]';
end

% initialize options
opts = [];
% opts.parallel = 12;

% generate graphs
FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);