%--------------------------------------------------------------------------
% PMA_STRUCT_Sort.m
% Optionally sort the labels before expanding the structured components
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Output = PMA_STRUCT_Sort(L,P,S,opts,Graph)

%--------------------------------------------------------------------------
% Task 1: Sort the graph elements according to some specified ordering
%--------------------------------------------------------------------------
% check if P.min and P.max are the same
if isfield(P,'min')
    if isequal(P.min,P.max)
        P = P.min;
    else
        error("Differing P.min and P.max catalogs are currently not supported for structured components");
    end
end

% find set of unique labeled labels
[uniqueL,~,J] = unique(Graph.L,'stable');

% get correct (P,R,S) for the current graph
P = P(ismember(L,uniqueL));
S = S(ismember(L,uniqueL));
R = histc(J, 1:numel(uniqueL))';

% ensure row vectors
uniqueL = uniqueL(:)'; P = P(:)'; S = S(:)'; R = R(:)';

% sort the structured components
if ~strcmpi(opts.structured.ordering,'none')
    [uniqueL,R,P,S,opts,Graph,B2,P2,iC] = SortFunction(uniqueL,R,P,S,opts,Graph);
end

%--------------------------------------------------------------------------
% Task 2: Expand the structured components to get unique graphs
%--------------------------------------------------------------------------
Output = PMA_STRUCT_ExpandGraphs(R,P,S,opts,Graph);

%--------------------------------------------------------------------------
% Task 3: Unsort to get original ordering
%--------------------------------------------------------------------------
% unsort the structured components
if ~strcmpi(opts.structured.ordering,'none')
    Output = UnsortFunction(iC,B2,P2,Output);
end

end
% sorting function
function [uniqueL,R,P,S,opts,Graph,B2,P2,iC] = SortFunction(uniqueL,R,P,S,opts,Graph)

% get ordering type
OrderType = opts.structured.ordering;

% get vectors that predict the expansion orders using the original
% ordering, used in unsorting (task 3)
[B2,P2] = Structured_ExpandPortsUnsort(S,P,R);

% expand the replicates of each vector
iC = repelem(uniqueL,R); iP = repelem(P,R); iS = repelem(S,R);

% expand the ports of each vector
while (sum(iS) > 0)
    [iC,iS,iP] = PMA_STRUCT_ExpandPorts(iC,iS,iP);
end

% copy original graph labels
OrigL = Graph.L;

% calculate the sorting metric
switch upper(OrderType(1))
    case 'T'
        SortMetric = P.*R; % weight total ports higher
    case 'P'
        SortMetric = (1000*P)+R; % weight ports higher
    case 'R'
        SortMetric = (1000*R)+P; % weight replicates higher
end

% use only the structured components
Structured_TotalPorts = SortMetric(S==1);
Structured_Idx = 1:length(SortMetric);
Structured_Idx = Structured_Idx(S==1);

% sort SortMetric
if strcmpi(OrderType(2),'D')
    [~,order] = sort(Structured_TotalPorts,'descend'); % descending
else
    [~,order] = sort(Structured_TotalPorts); % ascending
end

% get ordering of the structured components
order = Structured_Idx(order);

% combine ordering of (unsorted) simple and (sorted) structured components
order = [find(S==0),order];

% rearrange according to the ordering
uniqueL = uniqueL(order); R = R(order); P = P(order); S = S(order);

% relabel Graph.L and Graph.Ln according to rearranged C and R
Graph.L = repelem(uniqueL,R);
Graph.Ln = base2dec(Graph.L,36)';

% get relative index of the changed Graph.L with the original Graph.L
[~,loc] = ismember(Graph.L,OrigL);
uniqueLoc = unique(loc,'stable');
LocPlace = 1;
for i = 1:length(uniqueLoc)
   increment = 0;
   while (LocPlace <= length(loc)) && (loc(LocPlace) == uniqueLoc(i))
       loc(LocPlace) = loc(LocPlace) + increment;
       increment= increment + 1;
       LocPlace = LocPlace + 1;
   end
end

% sort Graph.A according to the relative indices
Graph.A = Graph.A(:,loc);
Graph.A = Graph.A(loc,:);

end

%Expand B and P vector according to P,R vector. However, each entry of BCopy
%shows whether the component it represents in the original C vector is a
%Structured Component or not. Each entry of P is the port number of the
%component that it represents in the original C vector
%each entry of B2 shows whether the component it represents
%in the original C vector is a Structured Component or not.
%Each entry of P is the port number of the component that it
%represents in the original C vector
function [S2,P] = Structured_ExpandPortsUnsort(S,P,R)

% expand the replicates in B and P
S = repelem(S,R)';
P = repelem(P,R)';

% create a copy of S
S2 = S(:);

% while structured components remain
while (sum(S) > 0)
    % find the next structured component in S
    iStruct = find(S,1,'first');

    % get the number of ports
    np = P(iStruct);

    % remove the current component
    S(iStruct) = []; P(iStruct) = []; S2(iStruct) = [];

    % change S and S2 accordingly
    S = [S(1:iStruct-1); zeros(np,1); S(iStruct:end)];
    S2 = [S2(1:iStruct-1); ones(np,1); S2(iStruct:end)];
    P = [P(1:iStruct-1); repmat(np,[np,1]); P(iStruct:end)];

end
end

% unsorting function
function Output = UnsortFunction(iC,S2,P2,Output)

% compare the iC(ports already expanded) with Output.L
[~,order] = ismember(iC,Output(1).L);

% change component indices
% increment used to keep track of component replicates
increment = zeros(1,length(Output(1).L));
for idx = 1:length(order)

    % index in Graph.L
    num = order(idx);

    % change the order number according to the increment vector
    order(idx) = order(idx) + increment(num);

    % now change the increment vector
    if (S2(idx) == 0)
        % if unstructured, simply add 1
        increment(num) = increment(num) + 1;
    end

    % if structured, simply add the number of ports in the original
    if (S2(idx) == 1)
        increment(num) = increment(num) + P2(idx);
    end
end

% update Output accordingly
for idx = 1:length(Output)
    Output(idx).A = Output(idx).A(:,order);
    Output(idx).A = Output(idx).A(order,:);
    Output(idx).L = Output(idx).L(order);
    Output(idx).Ln = Output(idx).Ln(order);
end
end