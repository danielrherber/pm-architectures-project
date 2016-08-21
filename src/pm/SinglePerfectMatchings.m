%--------------------------------------------------------------------------
% SinglePerfectMatchings.m
% Finds the perfect matchings of a complete graph for a subset the total
% number available. Therefore, one can find perfect matchings for graphs 
% larger than K20 but complete listings are still impractical.
% This algorithm is much slower for enumeration of all perfect matchigns 
% than the recursive one in PerfectMatchings.m
%--------------------------------------------------------------------------
% A = SinglePerfectMatchings(I,N)
% I : subset of integers between 1 and (N-1)!!
% N : number of vertices (should be even)
% A : matrix of perfect matchings from I grouped in sequential pairs
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 07/27/2015
% http://www.mathworks.com/matlabcentral/fileexchange/52301
%--------------------------------------------------------------------------
function A = SinglePerfectMatchings(I,N)
    % check if the values in I are too large for given N
    if any(I > prod(1:2:N-1))
        error('Error: An entry in I is too large for given N')
    end
    J = 1:2:N-1;
    Nmatchings = length(I); % number of perfect matchings to find
    P = [1,cumprod(J)]; % cumulative double factorial for N-2
    V = uint8(1:N); % create default list of available vertices 
    A = zeros(Nmatchings,N,'uint8'); % initialize output matrix
    % loop through I and find each perfect matching
    for k = 1:Nmatchings
        v = V; % copy list of available vertices
        i = I(k); % current entry in I
        for j = J
            q = (N-j+1)/2; % entry in B
            ind = ceil(i/P(q)); % calculate vertice index
            A(k,j) = v(end); % assign largest remaining value
            v(end) = []; % remove largest remaining value
            A(k,j+1) = v(ind); % assign selected value
            v(ind) = []; % remove the selected value 
            i = i - (ind-1)*P(q); % subtract to get index in subgraph
        end
%         % final entries
%         A(k,N-1) = v(end); 
%         A(k,N) = v(1);
    end
return