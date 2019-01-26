%--------------------------------------------------------------------------
% PMAex_md161635_suspensionConstraints.m
% Additional network structure constraints for Case Study 3 in the paper
% below
%--------------------------------------------------------------------------
% Herber DR, Guo T, Allison JT. Enumeration of Architectures With Perfect
% Matchings. ASME. J. Mech. Des. 2017; 139(5):051403. doi:10.1115/1.4036132
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [pp,A,feasibleFlag] = PMAex_md161635_suspensionConstraints(pp,A,feasibleFlag)
    %----------------------------------------------------------------------
    % s-u parallel connection path check
    %----------------------------------------------------------------------
    if feasibleFlag % only if the graph is currently feasible
        L = pp.labels.C; % extract labels
        I = logical(strcmpi(L,'s')+strcmpi(L,'u')+contains(L,'p','IgnoreCase',true)); % determine relevant indices
        At = A(I,I); % extra relevant subgraph
        W = PMA_ConnectivityMatrix(At,length(At)); % calculate connectivity matrix
        % check if a parallel connection path exists
        if W(1,2) == 1
            feasibleFlag = false;
        end
    end

    %----------------------------------------------------------------------
    % check for parallel cycles
    %----------------------------------------------------------------------
    if feasibleFlag % only if the graph is currently feasible
        L = pp.labels.C; % extract labels
        pIndex = find(contains(L,'p','IgnoreCase',true)); % 
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
            end
        end    
    end

    %----------------------------------------------------------------------
    % modify graphs for interchangeable series components
    %----------------------------------------------------------------------
    if feasibleFlag % only if the graph is currently feasible
        % extract
        Vfull = pp.NSC.Vfull; 
        L = pp.labels.C;
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
                % generate the new colored label
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
        pp.labels.N = base2dec(L,36)';
    end

end