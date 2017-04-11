%--------------------------------------------------------------------------
% ConnectivityMatrix.m
% Create connectivity matrix for a given adjacency matrix
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function W = ConnectivityMatrix(A,np)
    % create directed matrix
    M = sign( A + A' + eye(size(A)) );
    % connected network
    W = sign(M^np); % np is number of steps for connectivity
end