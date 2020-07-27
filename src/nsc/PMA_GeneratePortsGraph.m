%--------------------------------------------------------------------------
% PMA_GeneratePortsGraph.m
% Given an architecture problem, generate the ports graph and additional
% items
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [ports,idxp] = PMA_GeneratePortsGraph(P,R,L,NSC,idxp)

% number of components
n = sum(R);

% replicate the labels for each replicate
labelsL = repelem(L,R);
labelsL = labelsL(:);

% replicate the number of ports for each replicate
Vfull = repelem(P,R)';

% create mapping indices for each replicate
phi = repelem(1:n,repelem(P,R));

% replicate the labels for each replicates' ports
R2 = [];
for idx = R'
    R2 = [R2,1:idx];
end
R2 = string(R2);
R2 = R2(:); % column vector
labelsP = cellstr(repelem(strcat(labelsL,R2),Vfull));

% replicate the mandatory vector for each replicate
if NSC.flag.Mflag
    mandatory = repelem(NSC.M,R);
else
	mandatory = zeros(size(labelsL),'uint8'); % no components are mandatory
end

% replicate the simple vector for each replicate
if NSC.flag.Sflag
    simple = repelem(NSC.simple,R);
else
    simple = zeros(size(labelsL),'uint8'); % no components have unique simple
end

% replicate the loops vector for each replicate
loops = repelem(NSC.loops,R);

% get edges for each component's complete subgraph
I = []; J = []; V = []; % initialize
for idx = 1:n

    % find indices of a the complete graph (lower triangular part)
    [Ij,Jj,Vj] = find(tril(ones(Vfull(idx)),-1));

    I = [I, Ij'-1 + idxp]; % complete graph rows
    J = [J, Jj'-1 + idxp]; % complete graph columns
    V = [V, Vj']; % ones

	% increment port index
    idxp = idxp + Vfull(idx);

end

%% assign to output structure
grph.I = I; grph.J = J; grph.V = V; % complete subgraph indices
labels.P = labelsP; % port labels
labels.C = labelsL; % component labels
labels.N = nbase2dec(labelsL,36)'; % decimal component labels
ports.phi = phi;
ports.graph = grph;
ports.labels = labels;

% network structure constraints
NSC.Vfull = uint8(Vfull(:)');
NSC.M = uint8(mandatory(:)'); % expand mandatory vector
NSC.simple = uint8(simple(:)'); % expand simple vector
NSC.loops = uint8(loops(:)'); % expand loops vector
ports.NSC = NSC;

end