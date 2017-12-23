%--------------------------------------------------------------------------
% Structured_DisplayOpts.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli,Undergraduate Student,University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Structured_DisplayOpts(opts)
    disp(['Using ',opts.structured.isomethod, ' and ',...
     num2str(opts.structured.parellel),' workers ']);
    disp(['Ordering Method (if LOE) is ',opts.structured.order]);
    if opts.structured.simpleCheck == 1
       disp('Using Simple Checks Before Full Check');
    else
       disp('Not Using Simple Checks Before Full Check');
    end
end