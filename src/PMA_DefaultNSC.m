%--------------------------------------------------------------------------
% PMA_DefaultNSC.m
% Default network structure constraints for PM Architectures Project
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [NSC,L,P,R] = PMA_DefaultNSC(NSC,L,P,R)

%--------------------------------------------------------------------------
% parse (L,R,P)
% check labels
% standardize orientation
L = L(:)'; % row vector
if any(cellfun(@any,isstrprop(L,'digit')))
    error('L should not contain any digits')
end

% check port sequence
if isstruct(P)
    if ~isfield(P,'min') || ~isfield(P,'min')
        error('P.min and P.max needed')
    end

    % standardize orientation
    P.min = P.min(:)'; P.max = P.max(:)'; % row vector

else
    Pt = P(:)'; clear P % ensure row vector
    P.min = Pt; % single P assumes port distribution fixed
    P.max = Pt;
end

% check replicate sequence
if isstruct(R)
    if ~isfield(R,'min') || ~isfield(R,'min')
        error('R.min and R.max needed')
    end

    % standardize orientation
    R.min = R.min(:)'; R.max = R.max(:)'; % row vector
else
    Rt = R(:)'; clear R % ensure row vector
    R.max = Rt;

    % if any mandatory components (see note below on NSC.M
    if isfield(NSC,'M')
        if logical(any(NSC.M))
            R.min = zeros(size(Rt)); % initialize with zero lower bound

            % update R.min based on mandatory components
            R.min(logical(NSC.M)) = R.max(logical(NSC.M));

            % update connected flag
            if isfield(NSC,'connected')
                if ~NSC.connected
                    error('PMA:NSCMerror','Incompatible R, NSC.M, and NSC.connected')
                end
            end
            NSC.connected = true;

            % issue warning
            warning('PMA:NSCMwarning',['Using R and NSC.M together is obsolete\n'...
                'Please use R.min and R.max instead'])
        else
            R.min = Rt; % replicate distribution fixed
        end
    else
        R.min = Rt; % replicate distribution fixed
    end
end

% number of types
Nt = length(P.min);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% require connected graph (flag)
if isfield(NSC,'connected')
    % do nothing
else
    NSC.connected = false; % connected graph not required
    % NSC.connected = true; % connected graph required
end
NSC.connected = logical(NSC.connected); % ensure data type
NSC.flag.Cflag = NSC.connected;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% allow self loops (replicate-wise vector)
if isfield(NSC,'loops')
    if length(NSC.loops) == 1
        NSC.loops = NSC.loops*ones(Nt,1);
    end
else
    NSC.loops = inf(Nt,1); % allow as many loops as necessary
    % NSC.loops = ones(Nt,1); % allow a maximum of one loop
    % NSC.loops = zeros(Nt,1); % no loops
end
NSC.loops = uint8(NSC.loops); % ensure data type
NSC.flag.Lflag = logical(any(NSC.loops)); % ensure data type
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% reduced potential multiedge adjacency matrix
if isfield(NSC,'multiedgeA')
    % check if the matrix is symmetric
    if ~all(NSC.multiedgeA==NSC.multiedgeA') % not symmetric
        error('NSC.multiedgeA should be symmetric, fix?')
    end
    if length(NSC.multiedgeA) == 1
        NSC.multiedgeA = repelem(NSC.multiedgeA,Nt,Nt);
    end
else
    % NSC.multiedgeA = zero(Nt); % no connections allowed
    % NSC.multiedgeA = ones(Nt); % no multiedges, all connections allowed
    NSC.multiedgeA = inf(Nt); % multiedges and all connections allowed
end
NSC.multiedgeA = uint8(NSC.multiedgeA); % ensure data type
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% require simple components but maybe loops (replicate-wise vector)
if isfield(NSC,'simple')
    if length(NSC.simple) == 1
        NSC.simple = repelem(NSC.simple,Nt,1);
    end
else
    NSC.simple = zeros(Nt,1); % multiedges allowed
    % NSC.simple = ones(Nt,1); % no multiedges (but maybe loops)
end
NSC.simple = uint8(NSC.simple(:)); % ensure data type
NSC.flag.Sflag = logical(any(NSC.simple)); % ensure data type
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% reduced potential adjacency matrix
if isfield(NSC,'directA')
    % check if the matrix is symmetric
    if ~all(NSC.directA==NSC.directA','all') % not symmetric
        warning('Making NSC.directA symmetric')
        NSC.directA = NSC.directA & NSC.directA'; % make symmetric
    end
else
    % NSC.directA = zero(Nt); % no connections allowed
    NSC.directA = ones(Nt); % all connections allowed
end
NSC.directA = uint8(NSC.directA); % ensure data type
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% NOTE: no longer needed, use R.min(k) = R.max(k) instead to specify
% mandatory components and NSC.connected if a connected graph is
% required
% mandatory component boolean vector
if isfield(NSC,'M')
    if length(NSC.M) == 1
        NSC.M = NSC.M*ones(Nt,1);
    end
else
    NSC.M = zeros(1,Nt,'uint8'); % no components are mandatory
    % NSC.M = ones(1,Nt,'uint8'); % all components are mandatory
end
NSC.M = uint8(NSC.M); % ensure data type
NSC.flag.Mflag = logical(any(NSC.M)); % ensure data type
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% n x 3 vector of indices for pair constraints
if ~isfield(NSC,'lineTriple')
    NSC.lineTriple = []; % no pair constraints
end
NSC.flag.Bflag = logical(~isempty(NSC.lineTriple)); % ensure data type
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% minimum and maximum total number of replicates
if ~isfield(NSC,'Nr')
    NSC.Nr = [0 inf]; % no constraints
    % NSC.Nr = [2 4]; % between 2 and 4 replicates
end
NSC.Nr = uint64(NSC.Nr); % ensure data type
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% minimum and maximum total number of ports
if ~isfield(NSC,'Np')
    NSC.Np = [0 inf]; % no constraints
    % NSC.Np = [6 14]; % between 6 and 14 ports
end
NSC.Np = uint64(NSC.Np); % ensure data type
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% structured components boolean vector
% NSC.S = [];
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% user-defined catalog-only NSC checking function
if ~isfield(NSC,'userCatalogNSC')
    NSC.userCatalogNSC = []; % none by default
    % NSC.userCatalogNSC = @(L,Ls,Rs,Ps,NSC,opts) myCatalogNSCfunc(L,Ls,Rs,Ps,NSC,opts);
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% user-defined NSC checking function
if ~isfield(NSC,'userGraphNSC')
    NSC.userGraphNSC = []; % none by default
    % NSC.userGraphNSC = @(pp,A,feasibleFlag) myGraphNSCfunc(pp,A,feasibleFlag);
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% linear penalty constraints on the catalog
if ~isfield(NSC,'PenaltyMatrix')
    NSC.PenaltyMatrix = []; % none by default
    % NEED: examples
end
if ~isfield(NSC,'PenaltyValue')
    NSC.PenaltyValue = []; % none by default
    % NEED: examples
end

% standardize orientation
NSC.PenaltyValue = NSC.PenaltyValue(:)'; % row vector

% check dimensions
if ~isempty(NSC.PenaltyMatrix)
    if size(NSC.PenaltyMatrix,2) ~= Nt
       error('dimensions of NSC.PenaltyMatrix are invalid')
    end
end
if ~isempty(NSC.PenaltyValue)
    if any(size(NSC.PenaltyValue) ~= [1 size(NSC.PenaltyMatrix,1)])
       error('dimensions of NSC.PenaltyValue are invalid')
    end
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% linear satisfaction constraints on the catalog
if ~isfield(NSC,'SatisfactionMatrix')
    NSC.SatisfactionMatrix = []; % none by default
    % NEED: examples
end
if ~isfield(NSC,'SatisfactionValue')
    NSC.SatisfactionValue = []; % none by default
    % NEED: examples
end

% standardize orientation
NSC.SatisfactionValue = NSC.SatisfactionValue(:)'; % row vector

% check dimensions
if ~isempty(NSC.SatisfactionMatrix)
    if size(NSC.SatisfactionMatrix,2) ~= Nt
       error('dimensions of NSC.SatisfactionMatrix are invalid')
    end
end
if ~isempty(NSC.SatisfactionValue)
    if any(size(NSC.SatisfactionValue) ~= [1 size(NSC.SatisfactionMatrix,1)])
       error('dimensions of NSC.SatisfactionValue are invalid')
    end
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% combine NSC.simple and NSC.directA with NSC.multiedgeA
% extract
Am = NSC.multiedgeA; Ls = logical(NSC.simple); Ad = uint8(logical(NSC.directA));

% logical matrix for simple components
As = logical(Ls*Ls');

% combine with NSC.simple
Am(As) = min(Am(As),1);

% combine with NSC.directA
Am = Am.*Ad;

% assign
NSC.multiedgeA = Am;
%--------------------------------------------------------------------------

end