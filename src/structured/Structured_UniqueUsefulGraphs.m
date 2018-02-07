%--------------------------------------------------------------------------
% Structured_UniqueUsefulGraphs.m
% Given a set of unique simple graphs with structured components specified,
% find the set of unique structured graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli, Undergraduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = Structured_UniqueUsefulGraphs(C,R,P,NSC,opts,InputGraphs)
    % structured components vector
    S = NSC.S;

    % initialize
    FinalGraphs = [];

    % expand all input graphs with respect to the structured components
    parfor(idx = 1:length(InputGraphs), opts.structured.parallel)

        % get unique structured graphs for the current simple graph
        Graphs = Structured_Sort(C,P,S,opts,InputGraphs(idx));

        % combine
        FinalGraphs = [FinalGraphs,Graphs];
    end
    
    % output some stats to the command window
    if (opts.displevel > 0) % minimal
        ttime = toc; % stop the timer
        disp(['Found ',num2str(length(FinalGraphs)),' unique structured graphs in ', num2str(ttime),' s'])
    end
end