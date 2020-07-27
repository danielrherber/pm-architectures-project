%--------------------------------------------------------------------------
% PMA_ConnCompBins.m
% Determine the connected components (grouped in bins) of a graph
% represented by an adjacency matrix A
%--------------------------------------------------------------------------
% Based on the code by Alec Jacobson
% http://www.alecjacobson.com/weblog/?p=4203
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [n,bins,W] = PMA_ConnCompBins(A)

% ensure symmetric matrix and data type
A = logical(A); A = logical(A+A'+eye(size(A),'logical'));

% determine connected component boundaries
[p,~,r] = dmperm(A);

% number of connected components
n = numel(r)-1;

% determine connected component bins
if nargout >= 2

    % initialize bins for all connected components
    bins = repelem(1:n,diff(r));

    % unsort
    bins(p) = bins;

end

% determine connectivity matrix (1 indicates a path between 2 vertices)
if nargout >= 3
    W = bins == bins';
end

end