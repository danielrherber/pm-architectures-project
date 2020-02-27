%--------------------------------------------------------------------------
% PMA_PlotTreeEnumerate.m
% Visualize the tree algorithm
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
if isempty(G)
    return % because there is not a tree
end

% options
markersize = 20;
fontsize = 19; % 14;
s = 0.08;
nodeflag = false;
labelflag = false;

% change default interpreters
set(0,'DefaultTextInterpreter','latex');
set(0,'DefaultLegendInterpreter','latex');
set(0,'DefaultAxesTickLabelInterpreter','latex');

% obtain edge pair indices
IL = nodelist;
IR = 1:length(nodelist);

% remove dummy root node
IR(nodelist==0) = [];
IL(nodelist==0) = [];

% source node
source = find(pv==1);

% create adjacency matrix
A = zeros(max([IL,IR]));
A(sub2ind(size(A),IR,IL)) = 1;
A(sub2ind(size(A),IL,IR)) = 1;

% create figure
hf = figure('Color',[1 1 1],'Position', [100, 100, 1000, 200]); hold on

% create graph object
Grph = graph(A);

% plot tree
hp = plot(Grph,'k','Layout','layered','Sources',source,'AssignLayers','asap');

%
set(gca,'LooseInset',get(gca,'TightInset')+0.03)

% modify graph appearance
hp.EdgeColor = [0 0 0]; % change edge color
hp.EdgeAlpha = 1;
if nodeflag
    hp.NodeColor = [0 0 0];
    hp.Marker = '.';
    hp.MarkerSize = 2;
else
    hp.NodeColor = 'none'; % remove node marker
end
if ~labelflag
    hp.NodeLabel = []; % remove node labels
end

% extract data
X = hp.XData; Y = hp.YData;

% normalize X (between 0-1)
X = (X-min(X))/(max(X)-min(X));
ha = gca;
aspect = ha.PlotBoxAspectRatio;
X = X*(aspect(1)/aspect(2))*max(Y);
hp.XData = X;


% shift Y (down by one)
Y = Y - 1;
hp.YData = Y;

% get color spec
c = PMA_LabelColors(dec2base(Ln,36),opts.plots.colorlib);

% total number of nodes in the tree
Nnodes = length(labellist);

% plot edges
for idx = 1:Nnodes
    % coordinates
    X1 = X(IL(idx)); X2 = X(IR(idx)); Y1 = Y(IL(idx)); Y2 = Y(IR(idx));

    % length of the line
    l = sqrt((X1-X2)^2+(Y1-Y2)^2);

    % midpoint of the line
    Xm = 0.5*(X1+X2);
    Ym = 0.5*(Y1+Y2);

    % slope of the line
    m = (Y2-Y1)/(X2-X1);

    if m < 0
        XL = Xm + s*cos(atan(m));
        YL = Ym + s*sin(atan(m));
        XR = Xm - s*cos(atan(m));
        YR = Ym - s*sin(atan(m));
    else
        XL = Xm - s*cos(atan(m));
        YL = Ym - s*sin(atan(m));
        XR = Xm + s*cos(atan(m));
        YR = Ym + s*sin(atan(m));
    end

    % shift along line
%     XL = X2*(0.5+s) + X1*(0.5-s);
%     YL = Y2*(0.5+s) + Y1*(0.5-s);
%     XR = X2*(0.5-s) + X1*(0.5+s);
%     YR = Y2*(0.5-s) + Y1*(0.5+s);

    % plot nodes
    if feasiblelist(idx)
        plot(XL,YL,'.','color',c(labellist(2,idx),:),'markersize',markersize)
        plot(XR,YR,'.','color',c(labellist(1,idx),:),'markersize',markersize)
    else
        plot(XL,YL,'.','color',tint(c(labellist(2,idx),:),0.8),'markersize',markersize)
        plot(XR,YR,'.','color',tint(c(labellist(1,idx),:),0.8),'markersize',markersize)
    end
end

% number of edges
Np = size(G,2)/2;

% axis
ax = gca;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.Layer = 'top';
box on
ax.XTick = [];
ax.YTick = 0:Np;
ax.FontSize = fontsize-2;
ylabel('Edges Available','fontsize',fontsize,'Color',[0 0 0])

% change axis limits
% xlim([-0.03 1.03])
xlim([-0.03*max(X) 1.03*max(X)])
ylim([-0.05*Np 1.05*Np])
% axis equal
% axis tight

% (potentially) save plot
if opts.plots.saveflag
    figname = 'tree-visualization'; % name the figure
    foldername = opts.plots.path; % name the folder the figure will be placed in
    exportfigopts = '-png -pdf'; % export_fig options (see documentation)
    filename = [foldername,figname]; % combine folder string and name string
    str = ['export_fig ''',filename,''' ',exportfigopts]; % total str for export_fig
    eval(str) % evaluate and save the figure
end