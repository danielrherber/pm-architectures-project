%--------------------------------------------------------------------------
% RemovedColoredIsosMatlab.m
% Given a set of colored graphs, determine the set of nonisomorphic colored
% graphs, MATLAB only implementation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function UniqueGraphs = RemovedColoredIsosMatlab(Graphs,opts)

% output to the command window
if (opts.displevel > 1) % verbose
    disp('Now checking graphs for uniqueness...')
end

% number of graphs to check
n = length(Graphs);

% determine if parallel computing should be used
if n < 2000 % parallel computing would be slower
%     parallelTemp = 0; % no parallel computing
    Nbin = 1; % number of bins
else
%     parallelTemp = opts.parallel; 
%     Nbin = opts.Nbin; % need to add
    Nbin = 1; % number of bins
end

% initialize
nNonIso = 0; % number of nonisomorphic graphs found
% typearray = zeros(n,1);
% v = zeros(1,n); % keeps track of isomorphism status of the graphs

% compute various metrics once
G = cell(n,1);
% parfor (i = 1:n, parallelTemp)
for i = 1:n
    G{i} = graph(Graphs(i).A);
    G{i}.Nodes.Color = (Graphs(i).Ln)';
    Graphs(i).G = G{i};
end

% first graph is always unique so store it
bin(1).Graphs(1) = Graphs(1);
nNonIso = nNonIso + 1;
% v(1) = 1;

% initialize dispstat
dispstat('','init') % does not print anything
Ndispstat = floor((n-1)/100);

% check remaining graphs for uniqueness
for i = 2:n
    % get candidate graph information
    G1 = G{i};
    
    % initialize
    results = ones(min(Nbin,nNonIso),1);
    
% 	parfor (c = 1:min(Nbin,ind), Nbin) % this works now but is slow        
	for c = 1:min(Nbin,nNonIso)
        
        j = length(bin(c).Graphs); % number of graphs in the current bin
        IsoFlag = 0; % initialize isoFlag
        
        while (j > 0) && (IsoFlag == 0)
            G2 = bin(c).Graphs(j).G;
            % includes fix for bug 1465853
            if max(conncomp(G1)) ~= max(conncomp(G2))
                IsoFlag = false;
            else
                IsoFlag = isisomorphic(G1,G2,'NodeVariables','Color');
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
    
    % output some stats to the command window    
    if (opts.displevel > 1) % verbose
        if mod(i,Ndispstat) == 0
            dispstat(['Percentage complete: ',int2str(round(i/n*100)),' %'])
        end
    end
    
end

% combine all the bins
UniqueGraphs = []; % initialize
for c = 1:Nbin % go through each bin
    if ~isempty(bin(c)) % only if the bin is not empty
        UniqueGraphs = [UniqueGraphs, bin(c).Graphs];
    end
end

% output some stats to the command window
if (opts.displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Found ',num2str(length(UniqueGraphs)),' unique graphs in ', num2str(ttime),' s'])
end

end