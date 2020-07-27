%--------------------------------------------------------------------------
% PMA_STRUCT_GeneratePermutations.m
% Generate the permutations for a single structured component
%--------------------------------------------------------------------------
% outputs
% oPermLoops(k,:) are sequential pairs that indicate what indices of
% the structure component should be connected together
% oIntPortInd(k,i) is the index in the structure component that
% should be used when making an external edge
% oExtPortInd(k,i) is the index in the original adjacency matrix that
% should be used when making an external edge
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [oPermLoops,oIntPortInd,oExtPortInd] = PMA_STRUCT_GeneratePermutations(IExtCon,nl)

% total number of ports in the structured component
n = length(IExtCon) + 2*nl;

% unique permutations of the external connections (handles multi-edges)
PermsExtCons = unique(perms(IExtCon),'rows');

% get all internal connections (loops)
if nl > 0
    PermLoops = GenerateAllConnections(n,nl);
else % no loops
    PermLoops = [];
end
nPermLoops = size(PermLoops,1); % total number of internal permutations

% find remaining internal connections (not in PermLoops)
IntPortInd = nan(nPermLoops, n - 2*nl);
for k = 1:nPermLoops
    LeftOvers = 1:n; % initial list of ports
    LeftOvers(PermLoops(k,:)) = []; % remove ports that are in PermLoops
    IntPortInd(k,:) = LeftOvers; % ports that are externally connected
end

% combine internal and external permutation sets
oPermLoops = []; oIntPortInd = []; oExtPortInd = []; % initialize
for k = 1:size(PermsExtCons,1)
    oPermLoops = [oPermLoops; PermLoops];
    if isempty(PermLoops) % if there are no loops
        oIntPortInd = [oIntPortInd; 1:n];
        oExtPortInd = [oExtPortInd; repmat(PermsExtCons(k,:),1,1)];
    else % loops
        oIntPortInd = [oIntPortInd; IntPortInd];
        oExtPortInd = [oExtPortInd; repmat(PermsExtCons(k,:),nPermLoops,1)];
    end
end

end
% generates permutation set for loops
function PermLoops = GenerateAllConnections(n,nl)

% all combinations of the ports
I = nchoosek(1:n,2*nl);

% generate all perfect matchings
PM = PM_perfectMatchings(2*nl);

% number of perfect matchings
nPM = size(PM,1);

% initialize permutations of the loops
PermLoops = zeros(size(I,1)*nPM,2*nl);

% iterate through all possible combinations
idx = 1; % initialize
for i = 1:size(I,1)
    Sites = I(i,:);

    % go through each perfect matching
    for j = 1:size(PM,1)
        PermLoops(idx,:) = Sites(PM(j,:));
        idx = idx +1;
    end
end
end