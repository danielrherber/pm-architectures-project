%--------------------------------------------------------------------------
% ExpandPossibleAdj.m
% Expand the reduced adjacency matrix to the full possible adjacency matrix
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function A = ExpandPossibleAdj(A,R,NSC,varargin)

    if ~isempty(varargin)
        symflag = varargin{1};
    else
        symflag = 1;
    end

    % ensure data type
    A = uint8(A);

    % ensure that A is symmetric
    if symflag
        A = A + A' - ones(size(A),'uint8');
    end

    cumR = [0;cumsum(R(1:end-1))];
    for i = 1:length(R)
        in = cumR(i);
        for j = 1:R(i)-1
            ind = in + j;
            
            Li = A(1:ind,:);
            Ri = A(ind+1:end,:);
            A = [Li;Li(end,:);Ri];
            
            Li = A(:,1:ind);
            Ri = A(:,ind+1:end);
            A = [Li,Li(:,end),Ri];
        end
    end
    
    % START ENHANCEMENT: loops
    if NSC.flag.Cflag % if there are any required unique connections
        N = length(NSC.M); % total number of component replicates
        iDiag = 1:N+1:N^2; % indices for the diagonal elements
        A(iDiag) = ~(NSC.M & NSC.counts); % assign negated mandatory vector to the diagonal
    end
    % END ENHANCEMENT: loops
        
end