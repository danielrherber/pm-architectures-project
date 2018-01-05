%--------------------------------------------------------------------------
% Structured_RemovedColoredIsos.m
% Given a set of colored graphs, determine the set of nonisomorphic colored
% graphs, Python implementation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project

% Additional Contributor: Shangting Li, Undergraduate Student, University
% of Illinois at Urbana-Champaign
%--------------------------------------------------------------------------
function UniqueGraphs = Structured_RemovedColoredIsos(Structured_Graphs,opts)

% import isomorphism checking function
origdir = pwd; % original directory
pydir = mfoldername(mfilename('fullpath'),'python'); % python directory
cd(pydir) % change directory
py.importlib.import_module('detectiso_func4'); % import module 

n = length(Structured_Graphs);

%Get the port numbers and whether the graphs are structured or not
[P,B,~]= Structured_ShrinkLabel(Structured_Graphs(1));

%Get Structured_ Labels of the graph
Labels = Structured_Graphs.L;

%Get All Idx of Structured_ Component
structuredIdx = find(B==1);

%Number Indexes of the labels
Idxes = 1:length(Labels);

% compute various metrics once
pylist = cell(n,1);
colors = pylist;
nnode = zeros(n,1,'uint64');

if n < 2000 % parallel computing would be slower
    parallelTemp = 0; % no parallel computing
    Nbin = 1; % number of bins
else
    parallelTemp = opts.parallel; 
%     Nbin = opts.Nbin; % need to add
    Nbin = 1; % number of bins
end

nNonIso = 0;

parfor (i = 1:n, parallelTemp)
    [~,Isort] = sort(Structured_Graphs(i).Ln); % sort for unique representation
    adj = Structured_Graphs(i).A;
    adj = adj(Isort,:);
    adj = adj(:,Isort);
    nnode(i) = uint64(size(adj,1));
    colors{i} = uint64(Structured_Graphs(i).Ln(Isort));
    sumadj(i) = sum(adj(:));
    pylist{i} = int8(adj(:)');
end

%Compute the Internal Index and External Maps for each graph once
SubGraphs = cell(1,n);

for i = 1:n
    graph = Structured_Graphs(i);
    
    
    %For Every Structured_ Component
    for j = 1:length(structuredIdx)
            
        iStruct =  structuredIdx(j);
        
        %Get the port number of the structured Component
        np = P(iStruct);
        
        %Get the Structure Index of current structured component in the
        %expanded graph
        structPos = iStruct+sum(P(1:iStruct-1).*B(1:iStruct-1))-sum(B(1:iStruct-1));
        for k = 0:np-1
            idx = structPos+k;
            connection = find(graph.A(structPos,:) > 0);
        end
        
    end
    
end

for i = 1:n
    Structured_Graphs(i).nnode = nnode(i);
    Structured_Graphs(i).colors = colors{i};
    Structured_Graphs(i).sumadj = sumadj(i);
    Structured_Graphs(i).pylist = pylist{i};
    %+++Shangting's Addition+++
    Structured_Graphs(i).IntConnections = IntCellOfIndex{i};
    Structured_Graphs(i).ExtConnections = ExtCellOfMaps{i};
end

% first graph is always unique so store it
bin(1).Structured_Graphs(1) = Structured_Graphs(1);
nNonIso = nNonIso + 1;

for i = 2:n
    nnode1 = nnode(i);
    color1 = colors{i};
    pyadj1 = pylist{i};
    IntIndexes1 = IntCellOfIndex{i};
    ExtMaps1 = ExtCellOfMaps{i};
	for c = 1:min(Nbin,nNonIso) 
        j = length(bin(c).Structured_Graphs);
        %Get the internal connection of the bin first
        IntIndexes2 = bin(c).Structured_Graphs(j).IntConnections;
        IsoFlag = 0;   
        while (j > 0) && (IsoFlag == 0)
            %Check If the Internal connection is the same
            if checkInt(IntIndexes1,IntIndexes2)
                ExtMaps2 = bin(c).Structured_Graphs(j).ExtConnections;
                %Check if the external connection is the same
                hi = checkExt(ExtMaps1,ExtMaps2);
                if checkExt(ExtMaps1,ExtMaps2)
                    pyadj2 = bin(c).Structured_Graphs(j).pylist;
                    color2 = bin(c).Structured_Graphs(j).colors;
                    nnode2 = bin(c).Structured_Graphs(j).nnode;
                    %Run the full check
                    IsoFlag = py.detectiso_func4.detectiso(pyadj1,pyadj2,...
                                color1,color2,nnode1,nnode2);
                end
            end
            j = j - 1;
        end
        results(c) = IsoFlag;
	end
    
    if any(results) % not unique
        % v(i) = 0;
    else % unique
        % v(i) = 1;

        % get bin index
        J = mod(nNonIso, Nbin) + 1;
        
        % check if this is the first graph in the bin
        if (nNonIso + 1 <= Nbin) % first graph
            bin(J).Structured_Graphs(1) = Structured_Graphs(i);
        else % not the first graph
            bin(J).Structured_Graphs(end+1) = Structured_Graphs(i);
        end
        
        % increment since a unique graph was found
        nNonIso = nNonIso + 1;
    end
    
    % output some stats to the command window    
    if (opts.displevel > 1) % verbose
        if mod(i,Ndispstat) == 0
            dispstat(['Percentage complete: ',int2str(round(i/n*100)),' %'])
        end
    end
    
end

% return to the original directory
cd(origdir);

% combine all the bins
UniqueGraphs = []; % initialize
for c = 1:Nbin % go through each bin
    if ~isempty(bin(c)) % only if the bin is not empty
        UniqueGraphs = [UniqueGraphs, bin(c).Structured_Graphs];
    end
end

% remove some fields
UniqueGraphs = rmfield(UniqueGraphs,'colors');
UniqueGraphs = rmfield(UniqueGraphs,'pylist');
UniqueGraphs = rmfield(UniqueGraphs,'nnode');
UniqueGraphs = rmfield(UniqueGraphs,'sumadj');
UniqueGraphs = rmfield(UniqueGraphs,'IntConnections');
UniqueGraphs = rmfield(UniqueGraphs,'ExtConnections');
% output some stats to the command window
if (opts.displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Found ',num2str(length(UniqueGraphs)),' unique graphs in ', num2str(ttime),' s'])
end

end

%Function: Check if two graphs are definitely unique from the internal
%indexes.
function IsoFlag = checkInt(IntIndexes1,IntIndexes2)
    %If the lengths are not the same, they are unique
     if length(IntIndexes1) ~= length(IntIndexes2)
        IsoFlag = 0;
        return;
     end
     
     IsoFlag = 1;
     %Loop through every pair of indexes
     for a = 1:length(IntIndexes1)
        %If both are empty, treat it as not unique
        if isempty(IntIndexes1{a}) && isempty(IntIndexes2{a})
            continue;
        end
        
        %If finds one pair of indexes that are not the same, we conclude
        %that the two graphs are unique
        if ~isequal(IntIndexes1{a},IntIndexes2{a})
           IsoFlag = 0;
           return;
        end
     end
end


%Function: Check if two graphs are definitely unique from the External
%Check Map
function IsoFlag = checkExt(ExtMaps1,ExtMaps2)
 %If the lengths are not the same, they are unique
    if length(ExtMaps1) ~= length(ExtMaps2)
       IsoFlag = 0;
       return;
    end
    IsoFlag = 1;
    %Loop through every pair of Maps
     
    IMap = [];
    JMap = [];
    for b = 1:length(ExtMaps1)
        for c = 1:length(ExtMaps2)
             %We check if there is a graph in the other output that
             %is isomorphic to it. Then we record the number in
             %both Outputs
             map1 = ExtMaps1{b};
             map2 = ExtMaps2{c};
             
             if length(keys(map1))==length(keys(map2)) && all(strcmp(keys(map1),keys(map2))) 
                Keys = keys(map1);
                for d = 1:length(map1)
                    key = Keys{d};
                    map1(key) = sort(map1(key));
                    map2(key) = sort(map2(key));
                end
                if ~all(strcmp(values(map1),values(map2)));
                    IsoFlag = 0;
                    return;
                else
                    IMap = [IMap b];
                    JMap = [JMap c];
                end
             end
            %If we search through the entire OrigOutput and did
            %not find one, we conclude that this sort method
            %does not provide the same output
        end
        %If keys are not the same, we conclude that the two graphs are not
        %isomorphic
        
        %For every key-value pair, sort the value for comparison.
        
        %After sorting if the values are still not the same for the map,
        %then we conclude the two graphs are unique.
    end
    if sum(ismember(IMap,JMap)) ~= length(ExtMaps1)
        IsoFlag = 0;
    end
end