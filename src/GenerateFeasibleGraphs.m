%--------------------------------------------------------------------------
% GenerateFeasibleGraphs.m
% Given an architecture problem, generate a set of feasible graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Graphs = GenerateFeasibleGraphs(C,R,P,NSC,opts) 
    
    % number of ports
    Np = P'*R;
    
    % number of components
    Nc = sum(R);
    
    % generate ports graph
    [ports,~] = GenPortsGraph(P,R,C,NSC,1); 

    % generate candidate graphs
    [M,I,N] = GenerateCandidateGraphs(R,P,opts,Np,Nc,ports);
    
    % return if no graphs are present
    if N == 0
        Graphs = [];
        return
    end
    
    % remove basic isomorphism failures
    if opts.filterflag
        [M,I,N] = InitialPortIsoFilter(M,I,ports.phi,opts);
    end
    
    % set the custom function if it is present
    customfunFlag = 0;
    if isfield(opts,'customfun')
        customfunFlag = 1;
        CustomFeasibilityChecks = opts.customfun;
    else
        CustomFeasibilityChecks = @(pp,A,unusefulFlag) [pp,A,unusefulFlag];
    end
    
    % loop through the candidate graphs and check if they are
    % feasible/useful
    parfor (i = 1:N, opts.parallel)
 
        % graph is initially feasible
        unusefulFlag = 0;

        % local structure variable since pp might change
        pp = ports;
        
        % get the current PM vertices
        PM = M(i,:); 
        
        % three-tuple for the interconnectivity graph
        Ii = PM(1:2:end); % odd values
        Ji = PM(2:2:end); % even values
        
        % map edges from CP graph to CC graph with phi
        Icc = pp.phi(Ii); % rows
        Jcc = pp.phi(Ji); % columns
        Vcc = ones(size(Jcc)); % edges
        
        % connected components graph adjacency matrix
        Am = sparse(Icc,Jcc,Vcc,Nc,Nc);
        A = sign(Am + Am' + eye(Nc)) - eye(Nc);
        
        % remove stranded components using NSC.necessary
        if unusefulFlag ~= 1 % only if the graph is currently feasible
            [A,pp,unusefulFlag] = RemovedStranded(pp,A,unusefulFlag);
        end

        % check if the number of connections is correct
        if unusefulFlag ~= 1 % only if the graph is currently feasible
            if isfield(NSC,'counts') % check if the field exists
                if NSC.counts == 1 % check if we want this constraint
                    if ~all(sum(A) == pp.NSC.Vfull)
                        unusefulFlag = 1; % declare graph infeasible
                    end
                end
            end
        end
        
        % run custom infeasibility check function
        if unusefulFlag ~= 1 % only if the graph is currently feasible
            if customfunFlag
                [pp,A,unusefulFlag] = CustomFeasibilityChecks(pp,A,unusefulFlag);
            end
        end
        
        % if the graph is feasible, save it
        if unusefulFlag ~= 1
            myA = sign(A + A' + eye(length(A))) - eye(length(A)); % remove multiple edges and loops
            Graphs{i}.A = myA;
            Graphs{i}.L = pp.labels.C;
            Graphs{i}.Ln = pp.labels.N;
            Graphs{i}.removephi = pp.removephi;
            Graphs{i}.N = I(i); % perfect matching number
            Graphs{i}.Am = Am + Am'; % get multiedge adjacency matrix
        end
        
    end % end for loop

    % remove empty graphs
    if exist('Graphs','var')
        Graphs = Graphs(~cellfun('isempty',Graphs));
    else
        Graphs = [];
        return
    end
    
    % output some stats to the command window
    if (opts.displevel > 0) % minimal
        ttime = toc; % stop timer
        disp(['Found ',num2str(length(Graphs)), ' feasible, trimmed graphs in ', num2str(ttime),' s'])
    end
    
end % end function