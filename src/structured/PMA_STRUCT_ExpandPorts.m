%--------------------------------------------------------------------------
% PMA_STRUCT_ExpandPorts.m
% Expands (L,S,P) based on the number of ports in the first structured
% component in S
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [L,S,P] = PMA_STRUCT_ExpandPorts(L,S,P)

% ensure column vectors
L = L(:); S = S(:); P = P(:);

% find first structured component
iStruct = find(S,1,'first');

% number of ports for the current structured component
np = P(iStruct);

% remove entries for the current structured component
S(iStruct) = []; P(iStruct) = [];

% insert defaults
S = [S(1:iStruct-1); zeros(np,1); S(iStruct:end)]';
P = [P(1:iStruct-1); ones(np,1); P(iStruct:end)]';

% create new string
for k = 1:np
    Linsert{k} = [L{iStruct},num2str(k)];
end

% insert the new string
L = [L(1:iStruct-1); Linsert(:); L(iStruct+1:end)]';

end