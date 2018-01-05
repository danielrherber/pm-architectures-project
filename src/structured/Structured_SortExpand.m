%--------------------------------------------------------------------------
% Structured_SortExpand.m
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
function Output = Structured_SortExpand(Graph,P,B,C,opts)
    
    %==================================================================
    %Task 1: Sort the C vector and change P,R,Graph.A,Graph.L,Graph.Ln
    %Accordingly
    %==================================================================
    %Get the C Label from the very start
    %uniqueL = unique(Graph.L,'stable');
    [uniqueL, ~, J]=unique(Graph.L,'stable');
    P = P(ismember(C,uniqueL));
    B = B(ismember(C,uniqueL));
    R = histc(J, 1:numel(uniqueL))';
    if ~strcmp(opts.structured.order,'None')
        OrderType = opts.structured.order;
        %each entry of B2 shows whether the component it represents 
        %in the original C vector is a Sturctured Component or not. 
        %Each entry of P is the port number of the component that it 
        %represents in the original C vector

        %These two vectors are prediction of the original expansion. Used for
        %task 3.
        [B2,P2] = Structured_ExpandPortsUnsort(B,P,R);

        %Expand the replicates of each vector
        InterimC = repelem(uniqueL,R); InterimP = repelem(P,R); InterimB = repelem(B,R);

        %Expand the ports of each vector
        while(sum(InterimB) >0)
            [InterimC,InterimB,InterimP] = Structured_ExpandPorts(InterimC,InterimB,InterimP);
        end

        %Get a copy of the Original Graph Labels
        OrigL = Graph.L;

        %Change all the ordertype to uppercase to eliminate confusion
        OrderType = upper(OrderType);

        %Decide how to calculate the TotalPorts according to the first Char
        switch OrderType(1)
            case 'T'
                   TotalPorts = P.*R;
            case 'P'
                   TotalPorts = (1000*P)+R;
            case 'R'
                   TotalPorts = (1000*R)+P;
        end

        %Get strctured vector in TotalPorts 
        Structured_TotalPorts = TotalPorts(B==1);
        Structured_Idx = 1:length(TotalPorts);
        Structured_Idx = Structured_Idx(B==1);
        %Decide how to sort the TotalPorts according to the second Char
        if OrderType(2) == 'D'
            [~,order] = sort(Structured_TotalPorts,'descend');
        else
            [~,order] = sort(Structured_TotalPorts);
        end
        order = Structured_Idx(order);
        %The order to rearrange Original C,R,P according to sorting methods
        order = [find(B==0) order];

        %Rearrange each vector
        R = R(order); uniqueL = uniqueL(order);P = P(order);

        %Relabel Graph.L and Graph.Ln according to rearranged C and R
        Graph.L = Structured_ExpandVector(uniqueL,R)';
        Graph.Ln = base2dec(Graph.L,36)';
        %Get the relative index of the changed Graph.L with the original
        %Graph.L
        [~,loc] = ismember(Graph.L,OrigL);
        uniqueLoc = unique(loc,'stable');
        LocPlace = 1;
        for i = 1:length(uniqueLoc)
           increment = 0;
           while (LocPlace <= length(loc) && loc(LocPlace) == uniqueLoc(i))
               loc(LocPlace) = loc(LocPlace)+increment;
               increment= increment + 1;
               LocPlace = LocPlace + 1;
           end
        end

        %Change the Graph Adjacency Matrix according to the relative index of
        %the changed Graph.L with the original Graph.L
        Graph.A = Graph.A(:,loc);
        Graph.A = Graph.A(loc,:);
    end
    %==================================================================
    %Task 2: Expand the structuredNodes of sorted Graphs, P,B,R 
    %==================================================================
    Output = Structured_Expand(Graph,P,B,uniqueL,opts);

    %==================================================================
    %Task 3: Find the order to reverse the Output to the original expected
    %Output. And then use this order to reverse Output.L,Output.Ln,
    %Output.A
    %==================================================================
    
    %compare the InterimC(Actually Already been port expanded), and
    %Output.L
    if ~strcmp(opts.structured.order,'None')
        [~,order] = ismember(InterimC,Output(1).L);

        %We use increment vector to keep track of the duplicates of the
        %components and change their indexes accordingly. 

        increment = zeros(1,length(Output(1).L));
        for i = 1:length(order)
            %num is the index of the Graph.L
            num = order(i);

            %Change the order number accordign to the increment vector
            order(i) = order(i) + increment(num);

            %Also change the increment vector
            if (B2(i) == 0)
                %If unstructured, simply plus 1 and next time the unstructured
                %Ports appears its index would be added by 1
                increment(num) = increment(num)+1;
            end
                %If structured, simply plus the port number of the original 
                %vector and next time the unstructured Ports appears its index
                %would be added by the original port numbers
            if (B2(i) == 1)
                increment(num) = increment(num)+P2(i);
            end
        end

        %Change the Output.A,Output.L,Output.Ln accordingly
        for i = 1:length(Output)
            Output(i).A = Output(i).A(:,order);
            Output(i).A = Output(i).A(order,:);
            Output(i).L = Output(i).L(order);
            Output(i).Ln = Output(i).Ln(order);
        end
    end
end


%Expand B and P vector according to P,R vector. However, each entry of BCopy
%showes whether the component it represents in the original C vector is a 
%Sturctured Component or not. Each entry of P is the port number of the
%component that it represents in the original C vector
function [BCopy,P] = Structured_ExpandPortsUnsort(B,P,R)
    %Expand the replicates in B and P
    B = Structured_ExpandVector(B,R);
    P = Structured_ExpandVector(P,R);
    BCopy = B(:);

    while (sum(B) > 0)
        %Find the next Structured_ Component in B
        iStruct = find(B,1,'first');

        %Get the number of ports
        np = P(iStruct); 

        %Remove the component it is dealing with first
        B(iStruct) = []; P(iStruct) = []; BCopy(iStruct) = [];

        %Change B and BCopy accordingly
        B = [B(1:iStruct-1); zeros(np,1); B(iStruct:end)];
        BCopy = [BCopy(1:iStruct-1); ones(np,1); BCopy(iStruct:end)];
        P = [P(1:iStruct-1); repmat(np,[np,1]); P(iStruct:end)]; 
    end
end

