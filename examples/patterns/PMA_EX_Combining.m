%--------------------------------------------------------------------------
% PMA_EX_Combining.m
% The combining pattern seeks a combination of exactly one option for
% each decision
%--------------------------------------------------------------------------
% D. Selva, B. Cameron, and E. Crawley, "Patterns in System Architecture
% Decisions," Syst Eng, vol. 19, no. 6, pp. 477–497, Nov. 2016, doi:
% 10.1002/sys.21370
% D. R. Herber, "Enhancements to the perfect matching approach for graph
% enumeration-based engineering challenges. In ASME 2020 International
% Design Engineering Technical Conferences, DETC2020-22774, Aug. 2020.
% W. L. Simmons, "A framework for decision support in systems architecting"
% PhD thesis, Massachusetts Institute of Technology, 2008.
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all

% EOR : Earth Orbit Rendezvous, {no, yes}
% EL  : Earth Launch Type, {orbit, direct}
% LOR : Lunar Orbit Rendezvous, {no, yes}
% MA  : Arrival at Moon, {orbit, direct}
% MD  : Departure from Moon, {orbit, direct}
% CMC : Command Module Crew, {2, 3}
% LMC : Lunar Module Crew, {0,1,2,3}
% SMF : Service Module Fuel Type, {cryogenic, storable}
% LMF : Lunar Module Fuel Type, {NA, cryogenic, storable}

% case number (see switch statement below)
casenum = 1;

switch casenum
    %----------------------------------------------------------------------
    case 1 % example from Selva2016

    %----------------------------------------------------------------------
    case 2 % example from Simmons2008
    NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) CombiningNSCfunc(L,Ls,Rs,Ps,NSC,opts);
end

% problem specification
L = {'EOR' 'EL' 'LOR' 'MA' 'MD' 'CMC' 'LMC' 'SMF' 'LMF'};
NL = length(L);
R.min = zeros(NL,1); R.max = [1 1 1 1 1 1 3 1 2]; % replicates
P.min = repelem(0,NL,1); P.max = P.min; % ports

% network structure constraints
NSC.loops = 0; % loops allowed
NSC.directA = zeros(NL);

% options
opts.plots.plotmax = 1;
opts.plots.labelnumflag = false;
opts.plots.randomize = true;
opts.algorithm = 'tree_v12BFS_mex';
opts.isomethod = 'none'; % no needed for the partitioning problem
opts.parallel = 0;
opts.algorithms.Nmax = 1e5;
opts.plots.saveflag = false;
opts.plots.outputtype = 'pdf';

% obtain all unique, feasible graphs
G1 = PMA_UniqueFeasibleGraphs(L,R,P,NSC,opts);

function [Ls,Rs,Ps] = CombiningNSCfunc(~,Ls,Rs,Ps,~,~)

% EORconstraint scope: EOR, earthLaunch
% If there is an Earth orbit rendezvous, then this implies that the
% earthLaunch decision must be equal to orbit, since it’s impossible to
% rendezvous without entering Earth orbit first
I1 = (Rs(:,1) == 1); % Earth orbit rendezvous
I2 = (Rs(:,2) ~= 0); % not orbit
failed = I1 & I2; % combine
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = []; % remove failed

% LORconstraint. scope: LOR, moonArrival
% If there is a lunar orbit rendezvous in the mission mode, this implies
% that the moonArrival Decision must be equal to orbit, since it’s
% impossible to complete the rendezvous maneuver without entering lunar
% orbit before descending to the lunar surface.
I1 = (Rs(:,3) == 1); % lunar orbit rendezvous
I2 = (Rs(:,4) ~= 0); % not orbit
failed = I1 & I2; % combine
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = []; % remove failed

% moonLeaving. scope: LOR, moonDeparture
% If there is a lunar orbit rendezvous in the mission mode, this implies
% that the moonDeparture Decision must be equal to orbit, since it’s
% impossible to complete the rendezvous maneuver without entering lunar
% orbit after ascending from the lunar surface
I1 = (Rs(:,3) == 1); % lunar orbit rendezvous
I2 = (Rs(:,5) ~= 0); % not orbit
failed = I1 & I2; % combine
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = []; % remove failed

% lmcmcrew. scope: lmcrew, cmcrew
% This constraint restricts the crew size of the lunar module to be less
% than or equal to the crew size of the command module
I1 = Rs(:,6)+2; % cmcrew
I2 = Rs(:,7); % lmCrew
failed = I1 < I2; % combine
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = []; % remove failed

% lmexists. scope: lmCrew, LOR
% This constraint forces lmCrew to be zero if there is no lunar orbit
% rendezvous
I1 = (Rs(:,3) == 0); % no lunar orbit rendezvous
I2 = (Rs(:,7) ~= 0); % lmCrew not zero
failed = I1 & I2; % combine
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = []; % remove failed

I1 = (Rs(:,3) == 1); % lunar orbit rendezvous
I2 = (Rs(:,7) == 0); % lmCrew zero
failed = I1 & I2; % combine
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = []; % remove failed

% lmFuelConstraint. scope: lmFuel, LOR
% This constraint forces lmFuel to be NA if there is no lunar orbit
% rendezvous
I1 = (Rs(:,3) == 1); % lunar orbit rendezvous
I2 = (Rs(:,9) == 0); % lmFuel NA
failed = I1 & I2; % combine
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = []; % remove failed

I1 = (Rs(:,3) == 0); % no lunar orbit rendezvous
I2 = (Rs(:,9) ~= 0); % no lmFuel NA
failed = I1 & I2; % combine
Ls(failed,:) = []; Ps(failed,:) = []; Rs(failed,:) = []; % remove failed

end