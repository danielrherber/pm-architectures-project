%--------------------------------------------------------------------------
% Structured_OrderingRuntimeAnalysis.m
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
%++++++++++++++++Test for Runtime++++++++++++++++++++++++++

%==============Basic Information For Graphs=======================
C = {'M','E','V','G','P','A','B'}; % label vector
%M->Motor
%E->Engine
%V->Vehicle
%G->Ground
%P->Planatery Gear
%A ->Three Port Connection point
%B-> Four Port Connection Point
P = [1 1 1 1 3 3 4]; % ports vector 
B = [1 1 1 1 1 1 1]; %All structured Vectors
NSC.counts = 1; % unique edges
NSC.A = ones(length(P));
NSC.A(6,6) = 0; % no A-A
NSC.A(7,7) = 0; % no B-B
NSC.A(7,6) = 0; % no B-A

R.min = [1 0 1 0 1 0 0]'; % replicates min vector
R.max = [2 1 1 1 1 1 1]';

%Issue: Cannot Set R.max for 'P' to 2, this would result in computationally
%infeasible runtime
opts = Structured_SetupOpts;

%opts.structured.isomethod = 'LOE';

Structured_DisplayOpts(opts);
%========================================================================
%Time Efficiency for Ordering or Structured_ Nodes Analysis
testTimeEfficiency = 1;
if (testTimeEfficiency)
    
    %Set the looping times to warm Matlab Up
    loopingTimes = 50;
    
    %Methods to Use
    methods = {'None','TA','TD','RA','RD','PA','PD'};
    
    %Set up the time matrix
    Times = zeros(loopingTimes,length(methods));
    
    %This is just for checking and FYI
    OUTPUTS = cell(1,7);
    
    %Specify length of graphs and workers used
    workers = opts.structured.parellel;

    %Start Loops
    for x = 1:loopingTimes     
        [P,C,R,NSC,~] = Structured_ShuffleGraph(P,B,R,C,NSC);
        FinalGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
        n = length(FinalGraphs);
        %Start to deal with each method
        for i = 1:length(methods)
           %Get record of how long each method used
           tic 
               opts.structured.order = methods{i};
               Output = [];

               %Deal with every graph using each method
               for j = 1:n
                   message = strcat({'The '}, num2str(x), {' Iteration '},...
                        num2str(i), {' Method '},...
                        num2str(j), {' Graph'});
                   disp(message)
                   graph = FinalGraphs(j);           
                   %Actual place to deal with the the Graph
                   Output = [Output Structured_SortExpand(graph,P,B,C,opts)];
               end

               %Keep an record once
               if x == 1
                  OUTPUTS{i} = Output; 
               end
           
           %Record the time the method takes
           Times(x,i) = toc;
        end
    end
    
    
    SaveFlag = 1;
    
    %Get first ten Times off just to make sure the Matlab is warmed up
    if loopingTimes >= 50
       Times = Times(11:end,:); 
    end
    
    %Calculate the measure for central Tendency and Spread
    Average = mean(Times);
    Std = std(Times);
    
    %Save the results if needed
    if SaveFlag && loopingTimes >= 50
        filepath = '../Output/';
        filename = strcat('Times_Ordering_',num2str(loopingTimes-10),'.mat');
        fullname = strcat(filepath,filename);
        save(fullname,'methods','Times','Average','Std');
    end
end