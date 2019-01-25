%--------------------------------------------------------------------------
% PMA_CheckNSCFeasibility.m
% Given a PM edge set, construct the graph and check for NSC satisfaction
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function  [A,L,Ln,rmphi,Am,feasibleFlag] = PMA_CheckNSCFeasibility(PM,Nc,phi,Iunsort,ports,Cflag,Bflag,Bm,customfunFlag,CustFeasChecks)

    % graph is initially feasible
    feasibleFlag = true;

    % three-tuple for the interconnectivity graph
    Ii = PM(1:2:end); % odd values
    Ji = PM(2:2:end); % even values

    % map edges from CP graph to CC graph with phi
    Icc = phi(Ii); % rows
    Jcc = phi(Ji); % columns
    Vcc = ones(size(Jcc)); % edges

    % connected components graph adjacency matrix (multiedge)
    Am = sparse([Icc,Jcc],[Jcc,Icc],[Vcc,Vcc],Nc,Nc); % symmetric matrix
    iDiag = 1:Nc+1:Nc^2; % diagonal entry linear indices
    Am(iDiag) = Am(iDiag)/2; % half 

    % unsort
    Am = Am(Iunsort,:);
    Am = Am(:,Iunsort);

    % remove stranded components using NSC.M
    if feasibleFlag % only if the graph is currently feasible
        [Am,ports,feasibleFlag] = PMA_RemovedStranded(ports,Am,feasibleFlag);
    end

    % check if the number of connections is correct
    if feasibleFlag % only if the graph is currently feasible
        if Cflag % check if this nsc is present
            % remove self loops and multi-edges
            A = sign(Am + Am' + eye(length(Am))) - eye(length(Am));
            % compare number of connections to port counts
            check = full(sum(A)) == ports.NSC.Vfull;
            % declare infeasible if any components with required
            % unique connections does not have this property
            if ~all(check(ports.NSC.counts==1))
                feasibleFlag = false; % declare graph infeasible
            end
        end
    end

    % check line-connectivity constraints
    if feasibleFlag % only if the graph is currently feasible
        if Bflag % check if this nsc is present
            feasibleFlag = PMA_CheckLineConstraints(Am,Bm,feasibleFlag);
        end
    end

    % run custom infeasibility check function
    if feasibleFlag % only if the graph is currently feasible
        if customfunFlag
            [ports,Am,feasibleFlag] = CustFeasChecks(ports,Am,feasibleFlag);
        end
    end

    % if the graph is feasible, save it
    if feasibleFlag
        A = full(Am);
        L = ports.labels.C;
        Ln = ports.labels.N;
        rmphi = ports.removephi;
        Am = A; % get multiedge adjacency matrix
    else % infeasible
        % dummy outputs
        A = []; L = []; Ln = []; rmphi = []; Am = [];
    end

end