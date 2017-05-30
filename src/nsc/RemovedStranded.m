%--------------------------------------------------------------------------
% RemovedStranded.m
% Find stranded components not connected to the mandatory components and
% remove
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [A,pp,unusefulFlag] = RemovedStranded(pp,A,unusefulFlag)

	% total number of components
    N = length(A);
    
    %     J = 1:N; % current matrix indices
    O = [];
    R = [];
    W = ConnectivityMatrix(A,N);
    
    % check if the graph is completely connected
    if (sum(W(:)) == N^2)
        % don't remove any vertices
    else
        S = find(pp.NSC.M);
        for i = S
            R = [R;find(W(:,i) == 0)];
        end
        R = sort(unique(R));
        % remove components stranded
        for j = length(R):-1:1
            A(R(j),:) = []; % remove rows
            A(:,R(j)) = []; % remove columns
            pp.labels.C(R(j)) = []; % remove labels
            pp.labels.N(R(j)) = []; % remove labels
            pp.NSC.Vfull(R(j)) = [];
            pp.NSC.M(R(j)) = [];
            pp.NSC.counts(R(j)) = [];
        end
        O = sort(R,1,'descend');
    end
    
    if isempty(A)
        unusefulFlag = 1;
    end
    
    pp.removephi = O;
    
end