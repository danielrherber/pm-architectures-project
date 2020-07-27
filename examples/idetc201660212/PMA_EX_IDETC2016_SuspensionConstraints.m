%--------------------------------------------------------------------------
% PMA_EX_IDETC2016_SuspensionConstraints.m
% Additional network structure constraints for Case Study 3 in the paper
% below
%--------------------------------------------------------------------------
% http://systemdesign.illinois.edu/publications/Her16b.pdf
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [pp,A,feasibleFlag] = PMA_EX_IDETC2016_SuspensionConstraints(pp,A,feasibleFlag)
%----------------------------------------------------------------------
% s-u parallel connection path check
%----------------------------------------------------------------------
if feasibleFlag % only if the graph is currently feasible
    L = pp.labels.C; % extract labels
    I = logical(strcmpi(L,'s')+strcmpi(L,'u')+contains(L,'p','IgnoreCase',true)); % determine relevant indices
    At = A(I,I); % extra relevant subgraph
    W = PMA_ConnectivityMatrix(At,length(At)); % calculate connectivity matrix
    % check if a parallel connection path exists
    if W(1,2) == 1
        feasibleFlag = false;
    end
end

end