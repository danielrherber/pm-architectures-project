%--------------------------------------------------------------------------
% Structured_Expand.m
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
function Structured_FinalGraphs = Structured_ExpandGraphs(C,R,P,B,NSC,opts)

    %If there is no field for structured, then Setup Opts for structured
    if ~isfield(opts,'structured')
        opts = Structured_SetupOpts;
    end
    
    %Generate Component Graphs
    ComponentGraphs = UniqueUsefulGraphs(C,R,P,NSC,opts);
    disp([num2str(length(ComponentGraphs)),' Component Graphs Found.']);
    %Initialize the final output
    Structured_FinalGraphs = [];
    
    %Specifies the order we sort the colored labels
    order = opts.structured.order;
    
    %Specifies the number of parellel workers in the process
    workers= opts.structured.parellel;
    
    %For every graph in ComponentGraphs. We expand the graphs to structured
    %graphs and store them into the output
    parfor(i = 1:length(ComponentGraphs),workers)
        disp(i)
        Graph = ComponentGraphs(i);
        if strcmpi(order,'None') == 1
            Structured_FinalGraphs = [Structured_FinalGraphs ...
                Structured_Expand(Graph,P,B,C,opts)];
        else
            Structured_FinalGraphs = [Structured_FinalGraphs ...
                Structured_SortExpand(P,B,C,R,Graph,opts)];
        end
    end
    
end