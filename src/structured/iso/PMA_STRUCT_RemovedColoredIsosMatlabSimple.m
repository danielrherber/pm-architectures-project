%--------------------------------------------------------------------------
% PMA_STRUCT_RemovedColoredIsosMatlabSimple.m
% Given a set of structured labeled graphs, determine the set of
% nonisomorphic structured labeled graphs, MATLAB only implementation with
% the simple checks
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Graphs = PMA_STRUCT_RemovedColoredIsosMatlabSimple(Graphs,opts,iStruct,np)

% obtain cell arrays used for the simple checks
if opts.structured.simplecheck
    [IntData,ExtData] = Structured_SimpleCheckConnections(Graphs,iStruct,np);
end

% output to the command window
if (opts.displevel > 1) % verbose
    disp('Now checking graphs for uniqueness...')
end

% number of graphs to check
n = length(Graphs);

% determine if parallel computing should be used
if n < 2000 % parallel computing would be slower
    parallelTemp = 0; % no parallel computing
    Nbin = 1; % number of bins
else
    parallelTemp = opts.parallel;
%     Nbin = opts.Nbin; % need to add
    Nbin = 1; % number of bins
end

% initialize
nNonIso = 0; % number of nonisomorphic graphs found
% typearray = zeros(n,1);
% v = zeros(1,n); % keeps track of isomorphism status of the graphs

% compute various metrics once
G = cell(n,1);
parfor (i = 1:n, parallelTemp)
% for i = 1:n
    G{i} = graph(Graphs(i).A);
    G{i}.Nodes.Color = (Graphs(i).Ln)';
end

% attach to the Graphs structure
for i = 1:n
    Graphs(i).G = G{i};
    Graphs(i).IntData = IntData{i};
    Graphs(i).ExtData = ExtData{i};
end

% first graph is always unique so store it
bin(1).Graphs(1) = Graphs(1);
nNonIso = nNonIso + 1;
% v(1) = 1;

% check remaining graphs for uniqueness
for i = 2:n

    % get candidate graph information
    G1 = G{i};
    IntIndice1 = IntData{i};
    ExtArray1 = ExtData{i};

    % initialize
    results = ones(min(Nbin,nNonIso),1);

    % parfor (c = 1:min(Nbin,nNonIso), parallelTemp) % this works now but is slow
	for c = 1:min(Nbin,nNonIso)

        j = length(bin(c).Graphs); % number of graphs in the current bin
        IsoFlag = 0; % initialize isoFlag

        while (j > 0) && (IsoFlag == 0)
            IntIndice2 = bin(c).Graphs(j).IntData;
            % check if the internal connections are the same
            if isequal(IntIndice1,IntIndice2)
                ExtArray2 = bin(c).Graphs(j).ExtData;
                % check if the external connections are the same
                if isequal(ExtArray1,ExtArray2)
                    G2 = bin(c).Graphs(j).G;
                    % includes fix for bug 1465853
                    if isequal(max(conncomp(G1)),max(conncomp(G2)))
                        IsoFlag = isisomorphic(G1,G2,'NodeVariables','Color');
                    else
                        IsoFlag = false;
                    end
                end
            end
            % if IsoFlag
            %     typearray(i) = bin(c).Graphs(j).N;
            % end
            j = j - 1;
        end
        results(c) = IsoFlag;
	end

    % check if the candidate graph is unique
    if any(results) % not unique
        % v(i) = 0;
    else % unique
        % v(i) = 1;

        % get bin index
        J = mod(nNonIso, Nbin) + 1;

        % check if this is the first graph in the bin
        if (nNonIso + 1 <= Nbin) % first graph
            bin(J).Graphs(1) = Graphs(i);
        else % not the first graph
            bin(J).Graphs(end+1) = Graphs(i);
        end

        % increment since a unique graph was found
        nNonIso = nNonIso + 1;
    end
end

% combine all the bins
UniqueGraphs = []; % initialize
for c = 1:Nbin % go through each bin
    if ~isempty(bin(c)) % only if the bin is not empty
        UniqueGraphs = [UniqueGraphs, bin(c).Graphs];
    end
end

% remove some fields
UniqueGraphs = rmfield(UniqueGraphs,'G');
UniqueGraphs = rmfield(UniqueGraphs,'IntData');
UniqueGraphs = rmfield(UniqueGraphs,'ExtData');

% output some stats to the command window
if (opts.displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Found ',num2str(length(UniqueGraphs)),' unique graphs in ', num2str(ttime),' s'])
end

end