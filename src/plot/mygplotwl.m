%--------------------------------------------------------------------------
% mygplotwl.m
% Custom gplot function with overlaid labels
%--------------------------------------------------------------------------
% based on https://www.mathworks.com/matlabcentral/fileexchange/1044
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [Xout,Yout] = mygplotwl(A,xy,in)

labelsca = in.labelsca;
nodecolor = in.nodecolor;
edgecolor = in.edgecolor;
edgestyle = in.edgestyle;
markersize = in.markersize;
fontsize = in.fontsize;
linewidth = in.linewidth;

[i,j,w] = find(A);
[ignore, p] = sort(max(i,j));
i = i(p);
j = j(p);
w = w(p);
% Create a long, NaN-separated list of line segments,
% rather than individual segments.

X = [ xy(i,1) xy(j,1) repmat(NaN,size(i))]';
Y = [ xy(i,2) xy(j,2) repmat(NaN,size(i))]';
X = X(:);
Y = Y(:);

if nargout==0,
%     if nargin<4,
%         plot(X, Y)
%     else
        plot(X, Y, 'o','markersize',markersize, 'MarkerEdgeColor', nodecolor,...
            'MarkerFaceColor',[1 1 1],...
            'Color',edgecolor,'LineStyle',edgestyle,'linewidth',linewidth); hold on
%     end
else
    Xout = X;
    Yout = Y;
end
hold on;
% plot(xy(:,1), xy(:,2), 'r.');
if(max(w) - min(w) > 0)
    cxs = (xy(i,1)  + xy(j,1)) ./ 2;
    cys = (xy(i,2)  + xy(j,2)) ./ 2;
    weighttextsca = cell(size(cxs));
    for iw=1:length(w)
        weighttextsca{iw} = int2str(w(iw)); % sprintf('%f',w(iw))
    end
    % text(cxs, cys, weighttextsca);
    % plot weights at center of segments
end
if(nargin < 3)
    labelsca=[];
end
if(~isempty(labelsca))
    text(xy(:,1)-0.04, xy(:,2)+0.01, labelsca, 'FontWeight', 'bold', 'color',[0 0 0],...
        'fontsize',fontsize);
    % plot node labels;
end

end