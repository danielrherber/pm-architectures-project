%--------------------------------------------------------------------------
% PMA_CheckNSCFeasibility.m
% Given a PM edge set, construct the graph and check for NSC satisfaction
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [A,L,Ln,rmphi,Amout,feasibleFlag] = PMA_CheckNSCFeasibility(PM,...
    Nc,phi,Iunsort,ports,Sflag,Bflag,Bm,customfunFlag,CustFeasChecks)

% dummy outputs
A = []; L = []; Ln = []; rmphi = []; Amout = [];

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

% make full and correct data type
Am = uint8(full(Am));

% remove stranded components using NSC.M
[Am,ports,feasibleFlag] = PMA_RemovedStranded(ports,Am,feasibleFlag);
if ~feasibleFlag
    return; % graph infeasible
end

% check if the number of loops (diagonal) connections is correct
Adiag = diag(Am)'; % loops
feasibleFlag = all(ports.NSC.loops >= Adiag); % check loops NSC
if ~feasibleFlag
    return; % graph infeasible
end

% check if the number of (off-diagonal) connections is correct
if Sflag % check if this nsc is present
    Aports = Am-diag(diag(Am)); % remove loops
    Aports = logical(Aports); % remove multiedges
    simpleCheck = ports.NSC.Vfull-2*diag(Am)'==sum(Aports,1);
    feasibleFlag = all(simpleCheck(logical(ports.NSC.simple))); % check simple NSC
    if ~feasibleFlag
        return; % graph infeasible
    end
end

% check line-connectivity constraints
if Bflag % check if this nsc is present
    feasibleFlag = PMA_CheckLineConstraints(Am,Bm,feasibleFlag);
    if ~feasibleFlag
        return; % graph infeasible
    end
end

% run custom infeasibility check function
if customfunFlag % check if this nsc is present
    [ports,Am,feasibleFlag] = CustFeasChecks(ports,Am,feasibleFlag);
    if ~feasibleFlag
        return; % graph infeasible
    end
end

% if the graph is feasible, save it
A = double(Am);
L = ports.labels.C;
Ln = ports.labels.N;
rmphi = ports.removephi;
Amout = A; % get multiedge adjacency matrix

end