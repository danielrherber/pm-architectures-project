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
function I = InversePerfectMatchings(V)
    N = length(V); % total number of vertices
    Ifixed = 1:N; % initialize list of available vertices
    I = 1; % initialize PM index
    B = cumprod(N-3:-2:1,'reverse');
    for i = 1:N/2-1
        Ifixed(V((i-1)*2+1)) = 0; % zero entry of left vertex
        A = find(nonzeros(Ifixed)==V(2*i)); % return first (and only) entry
        Ifixed(V(2*i)) = 0; % zero entry
        I = I + (A-1)*B(i); % sum
    end
end