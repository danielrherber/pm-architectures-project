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
function Output = Structured_Expand(Graph,P,B,C,opts)
    %Times the Graph Self-Connect index by 2 (1->2)
    Graph.A = Graph.A+diag(diag(Graph.A));
    
    %Get the True P,B,R of the graph (If the graph has R.min, R.max)
    [uniqueL, ~, J]=unique(Graph.L,'stable');
    P = P(ismember(C,uniqueL));
    B = B(ismember(C,uniqueL));
    R = histc(J, 1:numel(uniqueL))';
    
    %Use the true R to expand B and P
    B = Structured_ExpandVector(B,R)';
    P = Structured_ExpandVector(P,R)';
    
    % copy L
    L = Graph.L;
    % Call the recursive function below
    Output = Structured_Modify(Graph,P,B,L,opts);
end

function Output = Structured_Modify(Input,P,B,L,opts)

    % check if any structured components remain
    if (sum(B) == 0)
        Output = Input;
        %If we need isochecking and we use AIO then do Isocheck at this
        %step
        if opts.structured.isocheck == 1 && strcmpi(opts.structured.isomethod,'AIO') == 1
           if opts.structured.simpleCheck == 0
                Output = RemovedColoredIsos(Output,opts);
           else
                Output = Structured_RemovedColoredIsos(Output,opts);
           end
           
        end % no modifications needed
        return;
    end

    % find the location of the next structured component
    iStruct = find(B,1,'first');

    % number of ports for the current structured component
    np = P(iStruct); 
    
    % expand the vectors
    [L,B,P] = Structured_ExpandPorts(L,B,P);

    % 
    Mid = [];
    
    % go through each graph in Input
    for l = 1:length(Input)

        % extract current Graph
        Graph = Input(l);

        % extract adjacency matrix
        A = Graph.A;

        % adjacency matrix with 0 diagonal 
        Anodiag = A - diag(diag(A));

        % find external connections for current structured component
        Lo = find(Anodiag(iStruct,:));

        % vector of external connection indices handling multi-edges
        IExtCon = []; % initialize
        for k = 1:numel(Lo) % go through each connection
            IExtCon = [IExtCon; Lo(k)*ones(A(Lo(k),iStruct),1)];
        end

        % calculate the number of loops (internal connections)
        nl = Graph.A(iStruct,iStruct)/2;
        
        % generate all permutations (both loops and multi-edges)
        [PermLoops,StructPortInd,ExtPortInd] = Structured_GeneratePermutations(IExtCon,nl);

        % total number of permutations
        NPerms = size(StructPortInd,1);

        %------------------------------------------------------------------
        % task: modify graph - expand A
        %------------------------------------------------------------------
        % remove row/column in A for current structured component
        A(iStruct,:) = []; 
        A(:,iStruct) = [];

        % insert rows for each port in the current structured component
        for k = 1:np
            I = iStruct + k - 1;
            A = [A(:,1:I-1) zeros(length(A),1) A(:,I:end)];
            A = [A(1:I-1,:); zeros(1,length(A)); A(I:end,:)];
        end

        % add default internal connections (complete graph between ports)
        U = ones(np)-eye(np); % complete graph without loops
        S = iStruct-1; % shift amount
        [Icomplete,Jcomplete,~] = find(U);
        A = A + sparse(Icomplete+S,Jcomplete+S,1,length(A),length(A));

        % replicate A matrix for each permutation
        Acell = repmat({A},NPerms,1);

        %------------------------------------------------------------------
        % task: modify graph - internal connections
        %------------------------------------------------------------------
        % shift indices to be in the correct location in expanded A
        PermLoops = PermLoops + iStruct - 1;

        % add each loop
        for k = 1:NPerms
           for i = 1:size(PermLoops,2)/2
               I1 = PermLoops(k,2*i-1); % odd location in PermLoops
               I2 = PermLoops(k,2*i); % even location in PermLoops
               Acell{k}(I1,I2) = 1 + Acell{k}(I1,I2); % add connection
               Acell{k}(I2,I1) = Acell{k}(I1,I2); % symmetric
           end
        end

        %------------------------------------------------------------------
        % task: modify graph - external connections
        %------------------------------------------------------------------
        % shift indices to be in the correct location in expanded A
        StructPortInd = StructPortInd + iStruct - 1;

        % shift indices to be in the correct location in expanded A
        ExtPortInd = ExtPortInd + (ExtPortInd > iStruct)*(np - 1);

        % add each external connection
        for k = 1:NPerms
            for i = 1:size(StructPortInd,2)
               I1 = StructPortInd(k,i); % internal index
               I2 = ExtPortInd(k,i); % external index
               Acell{k}(I1,I2) = 1 + Acell{k}(I1,I2); % add connection
               Acell{k}(I2,I1) = Acell{k}(I1,I2); % symmetric
            end
        end

        % assign expanded labels
        Graph.L = L;
        Graph.Ln = base2dec(L,36)';
        
        % replicate graph structure
        Graph = repmat(Graph,NPerms,1);
        
        % assign new A matrices
        for k = 1:NPerms
            Graph(k).A = Acell{k};
        end
        
        % combine structures
        Mid = [Mid; Graph];
    end

    %If we choose LOE, then we do isocheck at intermediate step.
    %++++++++Do we need to implement simple checks in LOE as well?+++++++++++
    if (opts.structured.isocheck == 1 && strcmpi(opts.structured.isomethod,'LOE') == 1)
        displevel = opts.displevel; 
        opts.displevel = 0; % suppress displaying
        if opts.structured.simpleCheck == 0
            Mid = RemovedColoredIsos(Mid,opts);
        else
            Mid = Structured_RemovedColoredIsos(Mid,opts);
        end
        opts.displevel = displevel;
    end
    % recursive call
    Output = Structured_Modify(Mid,P,B,L,opts);

end