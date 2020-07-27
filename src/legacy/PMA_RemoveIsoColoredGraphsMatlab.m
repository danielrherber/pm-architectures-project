%--------------------------------------------------------------------------
% PMA_RemoveIsoColoredGraphsMatlab.m
% Given a set of labeled graphs, determine the set of nonisomorphic labeled
% graphs (matlab implementation)
%--------------------------------------------------------------------------
% NOTE: purpose of this function is only to maintain compatibility with a
% previous function name
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = PMA_RemoveIsoColoredGraphsMatlab(Graphs,opts)

% call new function
FinalGraphs = PMA_RemoveIsoLabeledGraphs(Graphs,opts);

end