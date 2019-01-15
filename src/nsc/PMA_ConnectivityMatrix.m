%--------------------------------------------------------------------------
% PMA_ConnectivityMatrix.m
% Create connectivity matrix for a given adjacency matrix
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function W = PMA_ConnectivityMatrix(A,np)
    % create directed matrix
    W = logical(A + A' + eye(size(A)));
    % connected network
    W = logical(W^np); % np is number of steps for connectivity
end