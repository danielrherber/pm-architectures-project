%--------------------------------------------------------------------------
% PMA_EX_MD161635_SuspensionConstraints.m
% Additional network structure constraints for Case Study 3 in the paper
% below
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017; 139(5):051403. doi:10.1115/1.4036132
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [pp,A,feasibleFlag] = PMA_EX_MD161635_SuspensionConstraints(pp,A,feasibleFlag)

% only if the graph is currently feasible
if ~feasibleFlag
    return % exit, graph infeasible
end

% extract
L = pp.labels.C; % extract labels
%--------------------------------------------------------------------------
% s-u parallel connection path check
%--------------------------------------------------------------------------
I = contains(L,{'s','u','p'},'IgnoreCase',true);
At = A(I,I); % extra relevant subgraph
[~,~,W] = PMA_ConnCompBins(At); % calculate connectivity matrix
% check if a parallel connection path exists
if W(1,2) == 1
    feasibleFlag = false; % exit, graph infeasible
    return
end

%--------------------------------------------------------------------------
% check for parallel cycles
%--------------------------------------------------------------------------
pIndex = find(contains(L,'p','IgnoreCase',true)); % determine relevant indices
% for each parallel component type
for k = 1:length(pIndex)
    otherIndex = pIndex; % local copy
    otherIndex(k) = []; % remove current p-type component
    At = A; % temporary adjacency matrix (connected components)
    At(:,otherIndex) = 0; % remove other parallel components
    At(otherIndex,:) = 0; % remove other parallel components
    cycleFlag = PMA_DetectCycle(At); % check for cycles
    if cycleFlag % if there are any cycles, graph is infeasible
        feasibleFlag = false;
        return; % exit, graph infeasible
    end
end

%--------------------------------------------------------------------------
% modify graphs for interchangeable series components
%--------------------------------------------------------------------------
% extract
Vfull = pp.NSC.Vfull;
while 1
    I = find(Vfull==2); % find 2-port components
    [row,col] = find(A(:,I)); % find row location of connections to 2-port components
    J = find(Vfull(row)==2,1,'first'); % find first connection with another 2-port component
    if isempty(J)
        break % no more 2-2 connections, leave loop
    else
        keep = min(I(col(J)),row(J)); % keep the smallest index
        remove = max(I(col(J)),row(J)); % remove the largest index
        % modify adjacency matrix
        A(:,keep) = A(:,keep) + A(:,remove); % combine connections
        A(keep,:) = A(keep,:) + A(remove,:); % combine connections
        A(:,remove) = []; %  remove component
        A(remove,:) = []; % remove component
        A = A - diag(diag(A)); % remove diagonal entries
        % the diagonal entry is always present in this procedure
        % generate the new label
        newlabel = [L{keep},L{remove}]; % combine previous
        newlabel = sort(newlabel); % sort for uniqueness
        L{keep} = newlabel; % assign new label
        L(remove) = []; % remove old label
        % remove old counts entry
        Vfull(remove) = [];
        % the keep entry is the same as before (2)
    end % end if isempty(J)
end % end while 1
% assign
pp.NSC.Vfull = Vfull;
pp.labels.C = L;
% pp.labels.N = nbase2dec(L,36)';
pp.labels.N = nan; % need to be updated later

end