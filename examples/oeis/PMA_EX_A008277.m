%--------------------------------------------------------------------------
% PMA_EX_A008277
% A008277, triangle of Stirling numbers of the second kind, S2(n,k),
% n >= 1, 1 <= k <= n
% 1, 1, 1, 1, 3, 1, 1, 7, 6, 1, 1, 15, 25, 10, 1, 1, 31, 90, 65, 15, 1, ...
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

n = 5; % number of elements (currently completed for n = 11)
k = 3; % number of nonempty partitions
L1 = cellstr(string(dec2base((1:n)+9,36)))'; L2{1} = 'PART';
L = horzcat(L1,L2); % labels
R.min = [ones(n,1);k]; R.max = [ones(n,1);k]; % replicates
P.min = [ones(n,1);1]; P.max = [ones(n,1);n]; % ports
NSC.simple = 1; % simple components
NSC.connected = 0; % connected graph not required
NSC.loops = 0; % no loops
A = ones(n+1);
A(end,end) = 0; % no part-part connections
A(1:end-1,1:end-1) = 0; % no element-element connections
NSC.directA = A;
NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) PMA_BipartiteSubcatalogFilters(L,Ls,Rs,Ps,NSC,opts);

% options
opts.algorithm = 'tree_v12DFS_mex';
opts.algorithms.Nmax = 1e7;
opts.isomethod = 'none'; % no needed for the partitioning problem
opts.parallel = true;
opts.plots.plotmax = 5;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

% number of graphs based on OEIS A008277
N = zeros(15,8);
N(1,1)   = [1];
N(2,1:2) = [1 1];
N(3,1:3) = [1 3 1];
N(4,1:4) = [1 7 6 1];
N(5,1:5) = [1 15 25 10 1];
N(6,1:6) = [1 31 90 65 15 1];
N(7,1:7) = [1 63 301 350 140 21 1];
N(8,:)   = [1 127 966 1701 1050 266 28 1];
N(9,:)   = [1 255 3025 7770 6951 2646 462 36];
N(10,:)  = [1 511 9330 34105 42525 22827 5880 750];
N(11,:)  = [1 1023 28501 145750 246730 179487 63987 11880];
N(12,:)  = [1 2047 86526 611501 1379400 1323652 627396 159027];
N(13,:)  = [1 4095 261625 2532530 7508501 9321312 5715424 1899612];
N(14,:)  = [1 8191 788970 10391745 40075035 63436373 49329280 20912320];
N(15,:)  = [1 16383 2375101 42355950 210766920 420693273 408741333 216627840];
n2 = N(n,k);

% compare number of graphs
disp("correct?")
disp(string(isequal(length(G1),n2)))

% The triangle S2(n, k) begins:
% n\k    1       2       3        4         5         6         7         8
% -------------------------------------------------------------------------
% 1  |   1
% 2  |   1       1
% 3  |   1       3       1
% 4  |   1       7       6        1
% 5  |   1      15      25       10         1
% 6  |   1      31      90       65        15         1
% 7  |   1      63     301      350       140        21         1
% 8  |   1     127     966     1701      1050       266        28         1
% 9  |   1     255    3025     7770      6951      2646       462        36
% 10 |   1     511    9330    34105     42525     22827      5880       750
% 11 |   1    1023   28501   145750    246730    179487     63987     11880
% 12 |   1    2047   86526   611501   1379400   1323652    627396    159027
% 13 |   1    4095  261625  2532530   7508501   9321312   5715424   1899612
% 14 |   1    8191  788970 10391745  40075035  63436373  49329280  20912320
% 15 |   1   16383 2375101 42355950 210766920 420693273 408741333 216627840