%--------------------------------------------------------------------------
% PMA_DefaultNSC.m
% Default network structure constraints for PM Architectures Project
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function NSC = PMA_DefaultNSC(NSC,P)

    % mandatory component boolean vector
    if isfield(NSC,'M')
        NSC.M = uint8(NSC.M); % change data type
    else
        NSC.M = zeros(1,length(P),'uint8'); % no components are mandatory
        % NSC.M = ones(1,length(P),'uint8'); % all components are mandatory
    end
    NSC.flag.Mflag = logical(any(NSC.M)); % ensure data type
        
    % reduced potential adjacency matrix 
    if isfield(NSC,'A')
        NSC.A = uint8(NSC.A); % change data type
    else
        % NSC.A = zero(length(P),'uint8'); % no connections are allowed
        NSC.A = ones(length(P),'uint8'); % all connections are allowed
    end

    %     % self loops flag
    %     if isfield(NSC,'self')
    %         NSC.self = uint8(NSC.self); % change data type
    %     else
    %         % NSC.self = uint8(0); % don't allow self loops
    %         NSC.self = uint8(1); % allow self loops
    %     end
    
    % vector for ensuring each component has the correct number of unique
    % connections
    if isfield(NSC,'counts')
        if length(NSC.counts) == 1
            NSC.counts = uint8(NSC.counts*ones(length(P),1)); % change data type
        else
            NSC.counts = uint8(NSC.counts); % change data type
        end
    else
        NSC.counts = uint8(0*ones(length(P),1)); % no connections need to be unique
        % NSC.counts = uint8(1*ones(length(P),1)); % all connections need to be unique
    end
    NSC.flag.Cflag = logical(any(NSC.counts)); % ensure data type
    
    % n x 3 vector of indices for pair constraints
    if ~isfield(NSC,'Bind')
        NSC.Bind = []; % no pair constraints
    end
    NSC.flag.Bflag = logical(~isempty(NSC.Bind)); % ensure data type

    % structured components boolean vector
    % NSC.S = [];
end