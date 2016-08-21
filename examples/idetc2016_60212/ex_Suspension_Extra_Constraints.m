function [pp,A,unusefulFlag] = ex_Suspension_Extra_Constraints(pp,A,unusefulFlag)
    %% parallel connection check
    if unusefulFlag ~= 1 % only if the graph is currently feasible
        MyKeep = [];
        temp = strcmp(pp.labels.C,'s');
        MyKeep = [MyKeep,find(temp)] ;
        temp = strcmp(pp.labels.C,'u');
        MyKeep = [MyKeep,find(temp)] ;
        temp = strcmp(pp.labels.C,'p');
        MyKeep = [MyKeep,find(temp)] ;
        MyA = A(MyKeep,MyKeep);
        W = ConnectivityMatrix(MyA,20);
        if W(1,2) == 1;
            unusefulFlag = 1;
        end
    end

    %% check for parallel cycles
    if unusefulFlag ~= 1 % only if the graph is currently feasible
        pIndex = find(strcmp(pp.labels.C,'p'));
        for k = pIndex % for each parallel connection
            otherIndex = setdiff(pIndex,k);
            myA = A; % temporary adjacency matrix (connected components)
            myA(:,otherIndex) = 0; % remove other parallel components
            myA(otherIndex,:) = 0; % remove other parallel components
            [cycleCount] = custom_cycleCountBacktrack('adjMatrix',myA); % check for cycles
            if sum(cycleCount) ~= 0 % if there are any cycles, graph is infeasible
                unusefulFlag = 1;
            end
        end    
    end

    %% modify graphs for interchangeable series components
    if unusefulFlag ~= 1 % only if the graph is currently feasible
        while 1
            I = find(pp.NCS.Vfull==2); % find 2-port components
            [row,col] = find(A(:,I)); % find row location of connections to 2-port components
            J = find(pp.NCS.Vfull(row)==2,1,'first'); % find first connection with another 2-port component
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
                A = A  - diag(diag(A)); % remove diagonal entries
                % the diagonal entry is always present in this procedure
                % generate the new colored label
                newlabel = [pp.labels.C{keep},pp.labels.C{remove}]; % combine previous
                newlabel = sort(newlabel); % sort for uniqueness
                pp.labels.C{keep} = newlabel; % assign new label
                pp.labels.C(remove) = []; % remove old label
                % hash the string label (convert the characters to numbers)
                
                str = double(newlabel); % string of numbers with spaces
                str(str==107) = 6;
                str(str==98) = 7;
                str(str==102) = 8;
                str = num2str(str);
                str(ismember(str,' ')) = []; % remove the spaces
                pp.labels.N(keep) = str2double(['99',str]); % assign new number
                pp.labels.N(remove) = []; % remove old number
                % remove old counts entry
                pp.NCS.Vfull(remove) = []; 
                % the keep entry is the same as before (2)
            end % end if isempty(J)
        end % end while 1
    end % end if unusefulFlag ~= 1

end