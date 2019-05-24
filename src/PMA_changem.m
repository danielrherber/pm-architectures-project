%--------------------------------------------------------------------------
% PMA_changem.m
% Substitute values in an array
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function B = PMA_changem(A, newv, oldv)

    % copy
    B = A;

    % go through each entry and replace
    for k = 1:numel(newv)
        B(A == oldv(k)) = newv(k);
    end
    
end