%--------------------------------------------------------------------------
% DefaultNSC.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function NSC = DefaultNSC(NSC,P)

    % necessary component boolean vector
    if isfield(NSC,'necessary')
        NSC.necessary = uint8(NSC.necessary); % change data type
    else
        NSC.necessary = zeros(1,length(P),'uint8'); % no components are necessary
%         NSC.necessary = ones(1,length(P),'uint8'); % all components are necessary
    end

    % reduced potential adjacency matrix 
    if isfield(NSC,'A')
        NSC.A = uint8(NSC.A); % change data type
    else
%         NSC.A = zero(length(P),'uint8'); % no connections are allowed
        NSC.A = ones(length(P),'uint8'); % all connections are allowed
    end

    % self loops flag
    if isfield(NSC,'self')
        NSC.self = uint8(NSC.self); % change data type
    else
%         NSC.self = uint8(0); % don't allow self loops
        NSC.self = uint8(1); % allow self loops
    end
    
    % flag for ensuring each component has the correct number of unique
    % connections
    if isfield(NSC,'counts')
        NSC.counts = uint8(NSC.counts); % change data type
    else
        NSC.counts = uint8(0); % connections need not be unique
%         NSC.counts = uint8(1); % connections need to be unique
    end

end