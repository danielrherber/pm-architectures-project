%--------------------------------------------------------------------------
% PMA_RemoveIsoColoredGraphsPython.m
% Given a set of labeled graphs, determine the set of nonisomorphic labeled
% graphs (python implementation)
%--------------------------------------------------------------------------
% NOTE: purpose of this function is only to maintain compatibility with a
% previous function name
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = PMA_RemoveIsoColoredGraphsPython(Graphs,opts)

% call new function
FinalGraphs = PMA_RemoveIsoLabeledGraphs(Graphs,opts);

end