%--------------------------------------------------------------------------
% PMA_EX_MD161635_SuspensionConstraints.m
% Additional network structure constraints for ADD TEXT
%--------------------------------------------------------------------------
% ADD REFERENCE
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [pp,A,feasibleFlag] = PMA_EX_MD181711_SuspensionConstraints(pp,A,feasibleFlag)

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

        % (NEW) check for long series components % <- added
        if length(newlabel) > 3
            feasibleFlag = false; return
        end

        % (NEW) check if label contains f, remove since the other % <- added
        % series components have no effect on the dynamic model
        if contains(newlabel,'f')
            feasibleFlag = false; return
        end

    end % end if isempty(J)
end % end while 1
% assign
pp.NSC.Vfull = Vfull;
pp.labels.C = L;
% pp.labels.N = nbase2dec(L,36)';
pp.labels.N = nan; % need to be updated later

%----------------------------------------------------------------------
% check for physically-equivalent parallel systems
%----------------------------------------------------------------------
if feasibleFlag % only if the graph is currently feasible
    L = pp.labels.C; % extract labels
    I = find(strcmpi(L,'k')+strcmpi(L,'b')); % determine relevant indices
    I = I(:)'; % row vector
    Ip = contains(L,'p','IgnoreCase',true); % determine p locations
    % go through each relevant component
    for k = I
        P = find(A(k,:)); % find the connections to the component
        % check if both connections are of type p
        if all(Ip(P))
            % determine what is connected to the parallel connectors
            Ip1 = A(P(1),:);
            Ip2 = A(P(2),:);
            % determine what components are same between connectors
            Similar = (Ip1&Ip2);
            % remove the considered component
            Similar(k) = 0;
            % check if the other components are similar
            other = strcmpi(L(Similar),'k')+strcmpi(L(Similar),'b');
            % if all components are similar, then unuseful
            if any(other) && ~isempty(other)
                feasibleFlag = false; return
            end
        end
    end
end

%----------------------------------------------------------------------
% check for bad F connections
%----------------------------------------------------------------------
% if feasibleFlag % only if the graph is currently feasible
%     L = pp.labels.C; % extract labels
%     If = find(contains(L,'f')); % determine f locations
%     % only if there exists at least one f
%     if ~isempty(If)
%         I = logical(A(If,:)); % determine indices of the connections
%         % check if both connections are u and s
%         if any(contains(L(I),'s')) && any(contains(L(I),'u'))
%             return
%         elseif all(contains(L(I),'p')) % if both connections are p type
%             At = A; % local copy
%             At(If,:) = []; % remove f component
%             At(:,If) = []; % remove f component
%             W = PMA_ConnectivityMatrix(At,length(At)); % calculate connectivity matrix
%             % check if the system is still completely connected
%             if ~all(W(:))
%                 % failed, f isolates two masses
%                 feasibleFlag = false; return
%             end
%         else
%             % failed, not (su) or (pp)
%             feasibleFlag = false; return
%         end
%     end
% end

end