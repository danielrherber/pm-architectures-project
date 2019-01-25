%--------------------------------------------------------------------------
% PMA_GenerateFeasibleGraphs.m
% Given an architecture problem, generate a set of feasible graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Graphs = PMA_GenerateFeasibleGraphs(C,R,P,NSC,opts,Sorts) 
    
    % extract 
    Cflag = NSC.flag.Cflag;
    Bflag = NSC.flag.Bflag;
    
    % number of ports
    Np = P'*R;
    
    % number of components
    Nc = sum(R);
    
    % generate ports graph
    [ports,~] = PMA_GeneratePortsGraph(P,R,C,NSC,1); 

    % generate candidate graphs
    [G,I,N] = PMA_GenerateCandidateGraphs(C,R,P,opts,Np,Nc,ports);
    
    % return if no graphs are present
    if N == 0
        Graphs = [];
        return
    end
    
    % remove basic isomorphism failures
    if opts.filterflag
        [G,I,N] = PMA_PortIsoFilter(G,I,ports.phi,opts);
    end
    
    % set the custom function if it is present
    customfunFlag = 0;
    if isfield(opts,'customfun')
        customfunFlag = 1;
        CustFeasChecks = opts.customfun;
    else
        CustFeasChecks = @(pp,A,feasibleFlag) [pp,A,feasibleFlag];
    end
    
    % create B matrix, if necessary
    if Bflag
        Bm = PMA_CreateBMatrix(Sorts.NSC.Bind,Sorts.R,Sorts.NSC);
    else
        Bm = [];
    end
    
    % needed to construct correct adjacency matrix
    phiSorted = ports.phi; 
    
    % generated ports graph with original ordering
    [ports,~] = PMA_GeneratePortsGraph(Sorts.P,Sorts.R,Sorts.C,Sorts.NSC,1);
    
    % indices to unsort adjacency matrix
    Iunsort = Sorts.I; 

    % initialize
    Graphs = struct('A',[],'L',[],'Ln',[],'removephi',[],'N',[],'Am',[]);
    [Graphs(1:N)] = Graphs;   
    F = zeros(N,1); % all graphs are infeasible
    
    % loop through the candidate graphs and check if they are feasible
    if opts.parallel == 0
        for idx = 1:N
            % check feasibility
            [A,L,Ln,rmphi,Am,f] = PMA_CheckNSCFeasibility(G(idx,:),Nc,...
                phiSorted,Iunsort,ports,Cflag,Bflag,Bm,customfunFlag,CustFeasChecks);
            
            % assign if the graph is feasible
            if f
                F(idx) = f;
                Graphs(idx).A = A;
                Graphs(idx).L = L;
                Graphs(idx).Ln = Ln;
                Graphs(idx).removephi = rmphi;
                Graphs(idx).N = I(idx);
                Graphs(idx).Am = Am;
            end

        end % end for loop
    else
        parfor (idx = 1:N, opts.parallel)
            % check feasibility
            [A,L,Ln,rmphi,Am,f] = PMA_CheckNSCFeasibility(G(idx,:),Nc,...
                phiSorted,Iunsort,ports,Cflag,Bflag,Bm,customfunFlag,CustFeasChecks);

            % assign if the graph is feasible
            if f
                F(idx) = f;
                Graphs(idx).A = A;
                Graphs(idx).L = L;
                Graphs(idx).Ln = Ln;
                Graphs(idx).removephi = rmphi;
                Graphs(idx).N = I(idx);
                Graphs(idx).Am = Am;
            end

        end % end for loop
    end
    
    % remove empty graphs
    Graphs(~F) = [];
    
    % output some stats to the command window
    if (opts.displevel > 0) % minimal
        ttime = toc; % stop timer
        disp(['Found ',num2str(length(Graphs)),' feasible graphs in ',num2str(ttime),' s'])
    end
    
end % end function