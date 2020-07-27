%--------------------------------------------------------------------------
% PMA_RemovedStranded.m
% Find stranded components that are not connected to the specified
% mandatory components and remove them from the graph
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [A,pp,feasibleFlag] = PMA_RemovedStranded(pp,A,feasibleFlag)

% extract
M = pp.NSC.M;

% initialize with no vertices removed
pp.removephi = [];

% check if no components are mandatory (so do not remove any)
if ~any(M)
    return % do nothing
end

% obtain connectivity matrix
[n,~,W] = PMA_ConnCompBins(A);

% check if we have a connected graph
if n ~= 1

    % find stranded components
    R = ~all(W(:,logical(M)),2);

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