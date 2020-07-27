%--------------------------------------------------------------------------
% PMA_ConnectivityMatrix.m
% Create connectivity matrix for a given adjacency matrix
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function W = PMA_ConnectivityMatrix(A,np)

% convert data type
A = uint64(A);

% create directed matrix
W = logical(A + A' + eye(size(A),'uint64'));

% connected network
W = logical(W^np); % np is number of steps for connectivity

end

% NOTE: check data types