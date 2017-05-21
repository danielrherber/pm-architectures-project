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
phi = []; ind = 0; mandatory = []; Vfull = []; counts = [];
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
        
        % does this replicate need unique connections? make the list
        if isfield(NSC,'counts')
           counts = [counts,NSC.counts(j)];
        end
        
        % replicate the number of ports for each replicate
        Vfull = [Vfull,P(j)];
        
        %
        labelsC = [labelsC,C{j}];

    end
end

% get egdes for each component's complete subgraph
for j = 1:n
    
    % find indices of a the complete graph (lower triangular part)
    [Ij,Jj,Vj] = find(tril(ones(Vfull(j)),-1)); 

    I = [I, Ij'-1 + i]; % complete graph rows
    J = [J, Jj'-1 + i]; % complete graph columns
    V = [V, Vj']; % ones
    
	% increment port index
    i = i + Vfull(j);
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
ports.NSC.counts = uint8(counts); % expand counts vector