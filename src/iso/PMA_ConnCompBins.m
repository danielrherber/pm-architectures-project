%--------------------------------------------------------------------------
% PMA_ConnCompBins.m
% 
%--------------------------------------------------------------------------
% Based on the code by Alec Jacobson
% http://www.alecjacobson.com/weblog/?p=4203
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [BINS,p] = PMA_ConnCompBins(A)
    % 
    [p,~,r] = dmperm(A'+speye(size(A)));

    % 
    BINS = cumsum(full(sparse(1,r(1:end-1),1,1,size(A,1))));

    % 
    BINS(p) = BINS;
end