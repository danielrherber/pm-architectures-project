%--------------------------------------------------------------------------
% PMA_PlotBGL.m
% Custom plotting function using a force directed layout
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function PMA_PlotBGL(A,L,PM,I,opts)

% plotting parameters
titlefontsize = 24;
nodefontsize = 24;
markerdiameter = 0.32;
markerlinewidth = 4;
linewidth = 4;
weightcolor = [0 0 0];
weightfontsize = nodefontsize/2;
weightmargin = 0.1;

% add numbers to each replicate
if opts.labelnumflag
    % find the indices for the different component types
    [C,~,IC] = unique(L,'stable');
    N = histcounts(IC);

    % add numbers to the labels
    Lnum = cell(length(C),1);
    for idx = 1:length(C)
        Lnum{idx} = strcat('\textsl{',C{idx},'}$_',string(1:N(idx)),'$');
    end
    Lnum = horzcat(Lnum{:});

    % make font size a bit smaller
    nodefontsize = 0.8*nodefontsize;
else
    Lnum = strcat('\textsl{',L,'}');
end

% compute number of components
n = length(A);

% make sparse
A = sparse(A);

% use springs to compute a graph layout
xy = kamada_kawai_spring_layout(A,'spring_constant',1e-2,'tol',1e-10);

% normalize layout
xy(:,1) = (xy(:,1)-min(xy(:,1)))./(max(xy(:,1)) - min(xy(:,1)));
xy(:,2) = (xy(:,2)-min(xy(:,2)))./(max(xy(:,2)) - min(xy(:,2)));
xy = 2*xy - 1;

% get color spec
c = PMA_LabelColors(L,opts.colorlib);

% find all the edges
[IA,JA,VA] = find(A);

% create a new figure and save handle
hf = figure; hold on
hf.Color = [1 1 1]; % change the figure background

% plot edges
for idx = 1:length(VA)
    x1 = xy(IA(idx),1); x2 = xy(JA(idx),1);
    y1 = xy(IA(idx),2); y2 = xy(JA(idx),2);

    % plot the edge
    hp = plot([x1,x2], [y1,y2], '-');
    hp.LineWidth = linewidth;
    hp.Color = [0 0 0];

    % add multiedge weights
    if VA(idx) ~= 1
        ht = text((x1+x2)/2,(y1+y2)/2,int2str(VA(idx)));
        ht.Interpreter = 'latex';
        ht.HorizontalAlignment = 'center';
        ht.VerticalAlignment = 'middle';
        ht.FontSize = weightfontsize;
        ht.Color = weightcolor;
        ht.Margin = weightmargin;
        ht.BackgroundColor = 'white';
        ht.Rotation = 180/pi*atan((y2-y1)/(x2-x1));
    end
end

% plot each component
for idx = 1:n
    % plot circle
    hr = rectangle();
    hr.Position = [xy(idx,1)-markerdiameter/2 xy(idx,2)-markerdiameter/2 markerdiameter markerdiameter];
    hr.Curvature = [1 1];
    hr.FaceColor = tint(c(idx,:),0.85);
    hr.EdgeColor = c(idx,:);
    hr.LineWidth = markerlinewidth;

    % plot label
    ht = text(xy(idx,1),xy(idx,2)-0.03,Lnum{idx});
    ht.Interpreter = 'latex';
    ht.HorizontalAlignment = 'center';
    ht.VerticalAlignment = 'middle';
    ht.FontSize = nodefontsize;
    ht.Margin = eps;
end

% add title
hl = title(['\textsl{PM ',num2str(PM),'}']);
hl.Interpreter = 'latex';
hl.FontSize = titlefontsize;

% turn off axis box
box off;

% get current axis
ha = gca;

% set 'equal' figure aspect ratio
axis equal

% turn off both axises
ha.XColor = 'none';
ha.YColor = 'none';

% set axis limits
ha.XLim = [-1.2 1.2];
ha.YLim = [-1.2 1.2];

% save the plot
if opts.saveflag
    switch opts.outputtype
        case 'pdf'
            figname = 'graphs'; % name the figure
            exportfigopts = '-pdf -append'; % export_fig options (see documentation)
        case 'png'
            figname = ['graph',num2str(I)]; % name the figure
            exportfigopts = '-png -m2'; % export_fig options (see documentation)
    end
    filename = [opts.path,figname]; % combine folder string and name string
    str = ['export_fig ''',filename,''' ',exportfigopts]; % total str for export_fig
    eval(str) % evaluate and save the figure
    close(hf) % close the figure
end
end