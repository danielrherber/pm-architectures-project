%--------------------------------------------------------------------------
% CreateBMatrix.m
% Create 3-D array with line-connectivity constraint information
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Bout = CreateBMatrix(Bind,R,NSC)

    % number of component types
    n = numel(R);
    
    % initialize reduce form
    Bin = ones(n,n,n);
    
    % for each triplet of indices, 0 the correct entry
    for k = 1:size(Bind,1)
        Bin(Bind(k,3),Bind(k,2),Bind(k,1)) = 0;
    end

    % total number of components
    N = sum(R);

    % initialize full form
    Bout = ones(N,N,N,'uint8');

    % temporary replicates vector
    Rt = R;
    
    % don't do loops enhancement
    NSC.flag.Cflag = 0;

    % go through each component and expand the correct matrix
    for k = 1:N
        % find the first nonzero entry
        I = find(Rt,1);
        % remove the specified component
        Rt(I) = Rt(I) - 1;
        % expand the component's possible adjecency matrix and store    
        Bout(:,:,k) = ExpandPossibleAdj(Bin(:,:,I),R,NSC,0);
    end

end