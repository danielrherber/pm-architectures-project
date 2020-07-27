%--------------------------------------------------------------------------
% PMA_CreateBMatrix.m
% Create 3-D array with line-connectivity constraint information
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Bout = PMA_CreateBMatrix(lineTriple,R,NSC)

% number of component types
n = numel(R);

% initialize reduce form
Bin = ones(n,n,n);

% for each triplet of indices, 0 the correct entry
for k = 1:size(lineTriple,1)
    Bin(lineTriple(k,3),lineTriple(k,2),lineTriple(k,1)) = 0;
end

% total number of components
N = sum(R);

% initialize full form
Bout = ones(N,N,N,'uint8');

% temporary replicates vector
Rt = R;

% don't do loops enhancement
NSC.flag.Sflag = 0;

% go through each component and expand the correct matrix
for k = 1:N

    % find the first nonzero entry
    I = find(Rt,1);

    % remove the specified component
    Rt(I) = Rt(I) - 1;

    % expand the component's possible adjacency matrix and store
    Bout(:,:,k) = PMA_ExpandPossibleAdj(Bin(:,:,I),R,NSC,0);

end

end