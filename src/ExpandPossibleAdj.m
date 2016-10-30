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
function A = ExpandPossibleAdj(A,R,NSC)

    cumR = [0;cumsum(R(1:end-1))];
    for i = 1:length(R)
        in = cumR(i);
        for j = 1:R(i)-1
            ind = in + j;
            Li = A(1:ind,:);
            Ri = A(ind+1:end,:);
                    Li(end,:);
            A = [Li;Li(end,:);Ri];
            Li = A(:,1:ind);
            Ri = A(:,ind+1:end);
            A = [Li,Li(:,end),Ri];
        end
    end

    % self loops?
    if NSC.self == 0
        for i = 1:length(A)
            A(i,i) = 0;
        end
    else
        for i = 1:length(A)
            A(i,i) = 1;
        end
    end
    % handled somewhere else

end