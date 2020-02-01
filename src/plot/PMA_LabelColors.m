%--------------------------------------------------------------------------
% PMA_LabelColors.m
% Given a specific string, output a specific color
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function c = PMA_LabelColors(L,lib)

% check if a custom label function is provided
if isa(lib,'function_handle')
    c = lib(L);
    return
end

% assign colors
switch lib
    case 0
        c = ColorLibrary0(L);
    case 1
        c = ColorLibrary1(L);
    case 2
        c = ColorLibrary2(L);
    otherwise
        error("color library not defined")
end

end
% all colors black
function c = ColorLibrary0(L)

% initialize
c = zeros(length(L),3);

end
% ordered material colors
function c = ColorLibrary1(L)

% obtain unique label indices
[~,~,IC] = unique(L);

% create color library
idx = 0;
idx = idx + 1; C(idx,:) = [244,67,54]; % red 500
idx = idx + 1; C(idx,:) = [139,195,74]; % lightGreen 500
idx = idx + 1; C(idx,:) = [3,169,244]; % lightBlue 500
idx = idx + 1; C(idx,:) = [255,152,0]; % orange 500
idx = idx + 1; C(idx,:) = [255,235,59]; % yellow 500
idx = idx + 1; C(idx,:) = [233,30,99]; % pink 500
idx = idx + 1; C(idx,:) = [0,188,212]; % cyan 500
idx = idx + 1; C(idx,:) = [205,220,57]; % lime 500
idx = idx + 1; C(idx,:) = [33,150,243]; % blue 500
idx = idx + 1; C(idx,:) = [76,175,80]; % green 500
idx = idx + 1; C(idx,:) = [255,193,7]; % amber 500
idx = idx + 1; C(idx,:) = [156,39,176]; % purple 500
idx = idx + 1; C(idx,:) = [103,58,183]; % deepPurple 500
idx = idx + 1; C(idx,:) = [96,125,139]; % blueGray 500
idx = idx + 1; C(idx,:) = [255,87,34]; % deepOrange 500
idx = idx + 1; C(idx,:) = [63,81,181]; % indigo 500
idx = idx + 1; C(idx,:) = [0,150,136]; % teal 500
idx = idx + 1; C(idx,:) = [255,87,34]; % deepOrange 500
idx = idx + 1; C(idx,:) = [121,85,72]; % brown 500
idx = idx + 1; C(idx,:) = [158,158,158]; % gray 500
idx = idx + 1; C(idx,:) = [96,125,139]; % blueGray 500

% only certain number of colors available
IC = min(idx,IC);

% map and scale colors
c = C(IC,:)/255;

end
% labeled material colors
function c = ColorLibrary2(L)

% initialize
c = zeros(length(L),3);

% go through each label and assign a color
for k = 1:length(L)
    switch upper(L{k})
        case 'A'
            ct = [255,193,7]/255; % amber material
        case 'B'
            ct = [33,150,243]/255; % blue material
        case 'C'
            ct = [0,188,212]/255; % cyan material
        case 'D'
            ct = [255,87,34]/255; % deep orange material
        case 'G'
            ct = [76,175,80]/255; % green material
        case 'I'
            ct = [63,81,181]/255; % indigo material
        case 'L'
            ct = [205,220,57]/255; % lime material
        case 'O'
            ct = [255,152,0]/255; % orange material
        case 'P'
            ct = [156,39,176]/255; % purple material
        case 'R'
            ct = [244,67,54]/255; % red material
        case 'S'
            ct = [121,85,72]/255; % brown material
        case 'U'
            ct = [121,85,72]/255; % brown material
        case 'X'
            ct = [233,30,99]/255; % pink material
        case 'Y'
            ct = [3,169,244]/255; % light blue material
        case 'Z'
            ct = [96,125,139]/255; % blue gray material
        otherwise % default
            ct = [0.95,0.95,0.95];
    end

    % assign
    c(k,:) = ct;
end

end