%--------------------------------------------------------------------------
% PMA_RemovedStranded.m
% Find stranded components not connected to mandatory components and remove
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [A,pp,feasibleFlag] = PMA_RemovedStranded(pp,A,feasibleFlag)

% obtain connectivity matrix
W = PMA_ConnectivityMatrix(A,length(A));

% check if the graph have no stranded components
if all(W,'all')
    pp.removephi = []; % no vertices removed
else
    % find stranded components
    R = ~all(W(:,logical(pp.NSC.M)),2);

    % removed stranded components
    if any(R)
        A(R,:) = []; % remove rows
        A(:,R) = []; % remove columns
        pp.labels.C(R) = []; % remove labels (strings)
        pp.labels.N(R) = []; % remove labels (numbers)
        pp.NSC.Vfull(R) = [];
        pp.NSC.M(R) = [];
        pp.NSC.simple(R) = [];
    end

    % sort removed components
    pp.removephi = sort(find(R),1,'descend');
end

% if there are no remaining vertices, graph is infeasible (unuseful)
if isempty(A)
    feasibleFlag = false;
end

end