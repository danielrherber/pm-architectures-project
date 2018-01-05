%--------------------------------------------------------------------------
% Structured_Bayrak2016.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli,Undergraduate Student,University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear
clc
close all
closeallbio

C = {'M','E','V','G','P','A','B'}; % label vector
%M->Motor
%E->Engine
%V->Vehicle
%G->Ground
%P->Planatery Gear
%A ->Three Port Connection point
%B-> Four Port Connection Point
P = [1 1 1 1 3 3 4]; % ports vector 
B = [1 1 1 1 1 0 1];
NSC.counts = 1; % unique edges
NSC.A = ones(length(P));
NSC.A(6,6) = 0; % no A-A
NSC.A(7,7) = 0; % no B-B
NSC.A(7,6) = 0; % no B-A

opts = Structured_SetupOpts;

num = 2;
switch num
    
    case 1
        %We have exactly one planetary gear
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 1 1 1]';
        num_planetary_gears = 1;
    case 2
        %We could have one or two planetary gear
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 2 1 1]';
        num_planetary_gears = 2;
end
disp(['Doing the Structured Graphs for ',...
     num2str(num_planetary_gears), ' Planetary Gears']);
%Display All options for structured
Structured_DisplayOpts(opts)
tic
    %Execute the command to find Unique Structured Graphs
    Output = Structured_ExpandGraphs(C,R,P,B,NSC,opts);
    if num == 2
       save('Output/Example2Output.mat','Output');
    end
time = toc;

%Found Graphs
disp(['Found ',num2str(length(Output)),' unique graphs in ', num2str(time),' s'])