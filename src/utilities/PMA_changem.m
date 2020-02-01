%--------------------------------------------------------------------------
% PMA_changem.m
% Substitute values in an array
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function B = PMA_changem(A,newv,oldv)

% copy input matrix
B = A;

% go through each entry and replace
for k = 1:numel(newv)
    B(A == oldv(k)) = newv(k);
end

end