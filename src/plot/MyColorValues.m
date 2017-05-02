%--------------------------------------------------------------------------
% MyColorValues.m
% Given a specific string, output a specific color
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------
function c = MyColorValues(L)
    switch L
        case 'R'
            c = [1,0,0]; % red
        case 'G'
            c = [0,0.6,0.36078431372]; % forestgreen
        case 'B'
            c = [0,0,1]; % blue
        case 'O'
            c = [0.99607843137,0.63529411764,0.22745098039]; % orange
        case 'P'
            c = [0.60784313725,0.27843137254,0.58823529411]; % purple
        case 'PP'
            c = [0,0,0]; % black
        case 'u'
            c = [1,0,0];
        case 's'
            c = [1,0,0];
        case 'L'
            c = [174,129,255]/255; % 
        case 'C'
            c = [230,219,116]/255; % 
        otherwise
            c = [1,1,1];
    end
end