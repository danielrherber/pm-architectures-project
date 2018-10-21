%--------------------------------------------------------------------------
% PMA_LabelColors.m
% Given a specific string, output a specific color
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function c = PMA_LabelColors(L)
    switch upper(L)
        case 'A'
            c = [255,193,7]/255; % amber material
        case 'B'
            c = [33,150,243]/255; % blue material
        case 'C'
            c = [0,188,212]/255; % cyan material
        case 'D'
            c = [255,87,34]/255; % deep orange material
        case 'G'
            c = [76,175,80]/255; % green material
        case 'I'
            c = [63,81,181]/255; % indigo material
        case 'L'
            c = [205,220,57]/255; % lime material
        case 'O'
            c = [255,152,0]/255; % orange material
        case 'P'
            c = [156,39,176]/255; % purple material
        case 'R'
            c = [244,67,54]/255; % red material
        case 'S'
            c = [121,85,72]/255; % brown material
        case 'U'
            c = [121,85,72]/255; % brown material
        case 'X'
            c = [233,30,99]/255; % pink material
        case 'Y'
            c = [3,169,244]/255; % light blue material
        case 'Z'
            c = [96,125,139]/255; % blue grey material 
        otherwise % default
            c = [0.95,0.95,0.95];
    end
end

% old colors
% c = [1,0,0]; % red
% c = [0,0,1]; % blue
% c = [0,0.6,0.36078431372]; % forestgreen
% c = [0.99607843137,0.63529411764,0.22745098039]; % orange
% c = [0.60784313725,0.27843137254,0.58823529411]; % purple