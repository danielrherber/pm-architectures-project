%--------------------------------------------------------------------------
% InitialPortIsoFilter.m
% Apply the initial port-type isomorphism filter to remove isomorphic
% graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------
function [M,I,N] = InitialPortIsoFilter(M,I,phi)

% substitute values in data array, same as changem
Msum = M;
oldval = 1:length(phi);
for k = 1:numel(phi)
    Msum(M == oldval(k)) = phi(k);
end

% extract on the unique rows
[~,IA] = unique(Msum,'rows');

% get new set of graphs
M = M(IA,:);

% get pms of new set of graphs
I = I(IA);

% total number of graphs remaining
N = size(M,1);

% show stats on the command windows
disp(['Only ',num2str(N), ' remaining after initial port-type isomorphism check'])

end