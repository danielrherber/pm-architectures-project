%--------------------------------------------------------------------------
% PMA_CalcUniqueGraphBnds.m
% Using (P,R), determine upper and lower bound on the number of unique
% graphs with no additional network structure constraints
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [L,U] = PMA_CalcUniqueGraphBnds(P,R)

% total number of ports
N = dot(P,R);

% upper bound on the number of unique graphs based on double factorial
U = prod(1:2:N-1);

% calculate individual upper bounds on number of isomorphic permutations
i = factorial(R).*(factorial(P)).^R;

% calculate total number of potential of isomorphic permutations
I = prod(i);

% divide by upper bound on isomorphic permutations
L = U/I;

end