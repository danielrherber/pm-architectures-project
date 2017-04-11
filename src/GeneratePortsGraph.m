%--------------------------------------------------------------------------
% GeneratePortsGraph.m
% Given an architecture problem, generate the ports graph and additional
% items
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [ports,i] = GeneratePortsGraph(P,R,C,NSC,i)

% number of components
n = sum(R);

% initialize
I = []; J = []; V = [];
phi = []; ind = 0; mandatory = []; Vfull = [];
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
        % is this replicate mandatory? make the list
        if isfield(NSC,'M')
            mandatory = [mandatory,NSC.M(j)];
        end
        % replicate the number of ports for each replicate
        Vfull = [Vfull,P(j)];
        %
        labelsC = [labelsC,C{j}];
        %
%         labelsCnum = [labelsCnum,j];
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
%--------------------------------------------------------------------------
% new method
ports.labels.N = base2dec(upper(labelsC),36)';
% old method
% ports.labels.N = labelsCnum;
%--------------------------------------------------------------------------

% network structure constraints
ports.NSC = NSC; % copy current NSC structure
ports.NSC.Vfull = uint8(Vfull);
ports.NSC.M = uint8(mandatory); % expanded mandatory vector

% old stuff
% if isfield(NSC,'mandatory')
%     ports.NSC.M = uint8(mandatory);
% else
% 	ports.NSC.M = zeros(length(P),'uint8'); % no components are mandatory
% end % some moved above
% 
% if isfield(NSC,'A')
% 	ports.NSC.A = uint8(NSC.A);
% else
%     ports.NSC.A = ones(length(P),'uint8'); % all connections are allowed
% end
% 
% if isfield(NSC,'self')
% 	ports.NSC.self = uint8(NSC.self);
% else
%     ports.NSC.self = uint8(1); % allow self loops
% end
% 
% if isfield(NSC,'counts')
%     ports.NSC.counts = uint8(NSC.counts);
% else
%     ports.NSC.counts = uint8(0); % connected need not be unique
% end