% http://www.mathworks.com/matlabcentral/fileexchange/47246-color-tints/content//tint.m

function colorTint = tint(varargin)
%TINT   Create tint of a color or colormap
%
%   TINT(color,factor) takes rgb color (n-by-3, values between 0 and 1) or
%   colormap and factor (scalar, between 0 and 1, 0 = original, 1 = white)
%   and returns the tint (same size as color)
%
%   TINT(color) takes rgb color (n-by-3, values between 0 and 1) or
%   colormap and shows example tints 
%
%   Examples:
%       tint([1 0 0],0.5)  % returns a tint of red
%       tint(jet(9),0.5)   % returns a tint of each color of jet colormap
%       tint([1 0 0])      % displays example tints of red
%       tint(jet(9))       % displays example tints of jet colormap 

narginchk(1,2);
p = inputParser;
p.addRequired('color',...
    @(x) validateattributes(x,...
    {'numeric'},{'nonempty','ncols',3,'>=', 0,'<=', 1}));
p.addOptional('factor',[],...
    @(x) validateattributes(x,...
    {'numeric'},{'scalar','>=', 0,'<=', 1}));
p.parse(varargin{:});
color = p.Results.color;
factor = p.Results.factor;

switch nargin
    case 2
        colorTint = (1-color)*factor + color;
    case 1
        nColors = size(color,1);
        nTints = 11;
        factors = linspace(0,1,nTints);
        figure
        hold on
        for iColor = 1:nColors
            for iTint = 1:nTints
                colorTintExample = tint(color(iColor,:),factors(iTint));
                patch([iColor (iColor+1) (iColor+1) iColor],[iTint iTint (iTint+1) (iTint+1)],...
                    colorTintExample,'edgecolor','none')
            end
            set(gca,'XTick',0.5+(1:nColors),'XTickLabel',1:nColors)
            set(gca,'YTick',0.5+(1:nTints),'YTickLabel',factors)
            axis tight
            xlabel('Color index')
            ylabel('Tint factor')
        end
end


end