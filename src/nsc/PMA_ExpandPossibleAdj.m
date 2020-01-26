%--------------------------------------------------------------------------
% PMA_ExpandPossibleAdj.m
% Expand the reduced adjacency matrix to the full possible adjacency matrix
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function A = PMA_ExpandPossibleAdj(A,R,NSC,varargin)

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

% expand elements of A based on R
A = repelem(A,R,R);

% START ENHANCEMENT: loops
if symflag
    N = length(A); % total number of component replicates
    iDiag = 1:N+1:N^2; % indices for the diagonal elements
%     if NSC.flag.Sflag % if there are any required unique connections
%         A(iDiag) = A(iDiag) & ~(NSC.M & NSC.simple); % assign negated mandatory vector to the diagonal
%     end
    A(iDiag) = A(iDiag) & NSC.loops; % assign allowed self loops
end
% END ENHANCEMENT: loops

end