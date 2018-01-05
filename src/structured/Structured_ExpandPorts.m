%--------------------------------------------------------------------------
% StructuredExpandPorts.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli,Undergraduate Student,University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [L,B,P] = Structured_ExpandPorts(L,B,P)

    % column vectors
    B = B(:); P = P(:);

    % find first structured component
    iStruct = find(B,1,'first');
    
    % number of ports for the current structured component
    np = P(iStruct); 

    % remove entries for the current structured component
    B(iStruct) = []; P(iStruct) = [];

    % insert defaults
    B = [B(1:iStruct-1); zeros(np,1); B(iStruct:end)]';
    P = [P(1:iStruct-1); ones(np,1); P(iStruct:end)]';

    % create new string
    for k = 1:np
        Linsert{k} = [L{iStruct},num2str(k)];
    end
    
    % insert the new string
    L = [L(1:iStruct-1) Linsert L(iStruct+1:end)];

end