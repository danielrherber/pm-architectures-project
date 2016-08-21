%--------------------------------------------------------------------------
% GenPortsGraph.m
% Given an architecture problem, generate the ports graph and additional
% items
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------
function [ports,i] = GenPortsGraph(P,R,C,NCS,i)

% number of components
n = sum(R);

% initialize
I = []; J = []; V = [];
phi = []; ind = 0; necessary = []; Vfull = [];
labelsC = {}; labelsP = {}; labelsCnum = [];

% loop through each component type
for j = 1:length(R)
    % loop through each replicate
    for k = 1:R(j)
        % component index in connected components graph
        ind = ind + 1;
        % loop through each port of the replicate
        for m = 1:P(j)
            % unique port label
            labelsP = [labelsP,[C{j},int2str(k)]];
            % component index
            phi = [phi,ind];
        end
        % is this replicate necessary? make the list
        if isfield(NCS,'necessary')
            necessary = [necessary,NCS.necessary(j)];
        end
        % replicate the number of ports for each replicate
        Vfull = [Vfull,P(j)];
        %
        labelsC = [labelsC,C{j}];
        %
        labelsCnum = [labelsCnum,j];
    end
end

% get egdes for each component's complete subgraph
for j = 1:n
    
    % find indices of a the complete graph (lower triangular part)
    [Ij,Jj,Vj] = find(tril(ones(Vfull(j)),-1)); 

    I = [I, Ij'-1 + i]; % complete graph rows
    J = [J, Jj'-1 + i]; % complete graph columns
    V = [V, Vj']; % ones

%     I = [I, K(Vfull(j)).I + i]; % complete graph rows
%     J = [J, K(Vfull(j)).J + i]; % complete graph columns
%     V = [V, K(Vfull(j)).V]; % ones

    i = i + Vfull(j); % increment port index
end

%% assign to output structure
ports.graph.I = I;
ports.graph.J = J;
ports.graph.V = V;
ports.phi = phi;
ports.labels.P = labelsP;
ports.labels.C = labelsC;
ports.labels.N = labelsCnum;

% network structure constraints
ports.NCS.Vfull = uint8(Vfull);

if isfield(NCS,'necessary')
    ports.NCS.necessary = uint8(necessary);
else
	ports.NCS.necessary = zeros(length(P),'uint8'); % no components are necessary
end

if isfield(NCS,'A')
	ports.NCS.A = uint8(NCS.A);
else
    ports.NCS.A = ones(length(P),'uint8'); % all connections are allowed
end

if isfield(NCS,'self')
	ports.NCS.self = uint8(NCS.self);
else
    ports.NCS.self = uint8(1); % allow self loops
end

if isfield(NCS,'counts')
    ports.NCS.counts = uint8(NCS.counts);
else
    ports.NCS.counts = uint8(0); % connected need not be unique
end