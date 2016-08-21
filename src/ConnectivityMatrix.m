%--------------------------------------------------------------------------
% ConnectivityMatrix.m
% Create connectivity matrix for a given adjacency matrix
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------
function W = ConnectivityMatrix(A,np)
    % create directed matrix
    M = sign( A + A' + eye(size(A)) );
    % connected network
    W = sign(M^np); % np is number of steps for connectivity
end