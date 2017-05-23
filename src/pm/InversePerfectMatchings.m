%--------------------------------------------------------------------------
% InversePerfectMatchings.m
% Given a row vector that represents a perfect matching, return the 
% corresponding perfect matching number in the enumerated list
%--------------------------------------------------------------------------
% I = InversePerfectMatchings(V)
% V : a row vector that represents a perfect matching
%       - Even elements are left vertices in edge sets
%       - Odd elements are right vertices in edge sets
%       - V must have an even length N
%       - Every integer between 1:N must be present in V
%       - Even elements are in a decreasing order with respect to the even 
%       element subset
% I : corresponding perfect matching number in the enumerated list
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 07/27/2015
% http://www.mathworks.com/matlabcentral/fileexchange/52301
%--------------------------------------------------------------------------
function Iout = InversePerfectMatchings(M,varargin)

    % parse inputs
    if ~isempty(varargin)
        parallelnum = varargin{1}; % parallel computing
    else
        parallelnum = 0; % no parallel computing
    end
    
    M = uint8(M); % ensure data type
    Nm = size(M,1); % find the number of graphs in M
    N = size(M,2); % total number of vertices
    Iout = ones(Nm,1); % initialize output
    Itemp = uint8(1:N); % initialize list of available vertices
    B = cumprod(N-3:-2:1,'reverse'); % cumulative double factorial

    parfor (k = 1:Nm, parallelnum)
        V = M(k,:); % current vertex set
        Ifixed = Itemp; % local copy
        I = 1; % initialize PM index
        for i = 1:N/2-1
            Ifixed(V((i-1)*2+1)) = 0; % zero entry of left vertex
            A = find(nonzeros(Ifixed)==V(2*i)); % return first (and only) entry
            Ifixed(V(2*i)) = 0; % zero entry of right vertex
            I = I + (A-1)*B(i); % sum
        end
        Iout(k) = I; % save to output
    end
end