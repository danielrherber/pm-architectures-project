%--------------------------------------------------------------------------
% StructuredExpandVector.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function output = Structured_ExpandVector(array,R)

    % initialize output
    output = [];
    
    % go through each replicate
    for k = 1:numel(R)
        output = [output; repmat(array(k),R(k),1)];
    end

end