%--------------------------------------------------------------------------
% PMA_GenerateFeasibleGraphs.m
% Given an architecture problem, generate a set of feasible graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Graphs = PMA_GenerateFeasibleGraphs(L,R,P,NSC,opts,Sorts)

% extract
Sflag = NSC.flag.Sflag;
Bflag = NSC.flag.Bflag;

% number of ports
Np = P'*R;

% return single empty graph if no ports
if Np == 0
    labelsL = repelem(L,R); labelsL = labelsL(:); % replicate the labels
    Graphs(1).A = zeros(length(labelsL)); % empty graph
    Graphs(1).L = labelsL;
    Graphs(1).Ln = nbase2dec(labelsL,36)';
    Graphs(1).removephi = [];
    Graphs(1).N = 0; % not a perfect matching
    Graphs(1).Am = zeros(length(labelsL)); % empty graph
    return
end

% number of components
Nc = sum(R);

% generate ports graph
[ports,~] = PMA_GeneratePortsGraph(P,R,L,NSC,1);

% generate candidate graphs
[G,I,N] = PMA_GenerateCandidateGraphs(L,R,P,opts,Np,Nc,ports);

% return if no graphs are present
if N == 0
    Graphs = [];
    return
end

% NOTE: for counting the number of candidate graphs using profiler
% for k = 1:size(G,1)
%     disp('')
% end

% remove basic isomorphism failures
if opts.filterflag
    [G,I,N] = PMA_PortIsoFilter(G,I,ports.phi,opts);
end

% set the custom function if it is present
if isempty(NSC.userGraphNSC)
    customfunFlag = false;
    CustFeasChecks = NSC.userGraphNSC;
else
    customfunFlag = true;
    CustFeasChecks = NSC.userGraphNSC;
end

% create B matrix, if necessary
if Bflag
    Bm = PMA_CreateBMatrix(Sorts.NSC.lineTriple,Sorts.R,Sorts.NSC);
else
    Bm = [];
end

% needed to construct correct adjacency matrix
phiSorted = ports.phi;

% generated ports graph with original ordering
Sorts.C = regexprep(Sorts.C,'[\d"]',''); % remove port numbers
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
            phiSorted,Iunsort,ports,Sflag,Bflag,Bm,customfunFlag,CustFeasChecks);

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
            phiSorted,Iunsort,ports,Sflag,Bflag,Bm,customfunFlag,CustFeasChecks);

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

% NOTE: for counting the number of feasible graphs using profiler
% for k = 1:length(Graphs)
%     disp('')
% end

% output some stats to the command window
if (opts.displevel > 0) % minimal
    ttime = toc; % stop timer
    disp(['Found ',num2str(length(Graphs)),' feasible graphs in ',num2str(ttime),' s'])
end

end % end function