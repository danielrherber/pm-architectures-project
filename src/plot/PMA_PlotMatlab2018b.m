%--------------------------------------------------------------------------
% PMA_PlotMatlab2018b.m
% Custom plotting function using built-in Matlab functions
% Particularly useful for unconnected graphs
% Syntax used is only available in r2018b
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function PMA_PlotMatlab2018b(A,L,PM,I,opts)

% plotting parameters
markersize = 24;
edgesize = 10;
yshift = 0.01;
linewidth = 2;
nodefontsize = 16;
titlefontsize = 24;

% add numbers to each replicate
if opts.labelnumflag
    % find the indices for the different component types
    [C,~,IC] = unique(L,'stable');
    N = histcounts(IC);

    % add numbers to the labels
    Lnum = cell(length(C),1);
    for idx = 1:length(C)
        Lnum{idx} = strcat('\textsl{',C{idx},'}$_{',string(1:N(idx)),'}$');
    end
    Lnum = horzcat(Lnum{:});
else
    Lnum = strcat('\textsl{',L,'}');
end

% get color spec
c = PMA_LabelColors(L,opts.colorlib);

% create a new figure and save handle
hf = figure;
hf.Color = [1 1 1]; % change the figure background

% create undirected graph object
G = graph(A);

% graph plot
if any(A(:) > 1) % check if multiedges are present
    [~,~,V] = find(tril(A));
    V = strrep(string(V),'1',''); % remove simple edge labels
    hg = plot(G,'k','NodeLabel',{},'EdgeLabel',V);
else
    hg = plot(G,'k','NodeLabel',{});
end

% set plot properties
hg.Interpreter = 'latex'; % set interpreter
hg.EdgeFontAngle = 'normal'; % set edge font angle
hg.EdgeFontSize = edgesize; % set edge font size
hg.MarkerSize = markersize; % set marker size
hg.NodeColor = c; % set node colors
hg.LineWidth = linewidth; % set connection width

% add node labels
X = hg.XData; Y = hg.YData;
for idx = 1:length(Lnum)
    text(X(idx),Y(idx)-yshift,Lnum{idx},...
        'Interpreter','latex','HorizontalAlignment','center',...
        'FontSize',nodefontsize)
end

% add title
title(['\textsl{PM ',num2str(PM),'}'],'Interpreter','latex',...
    'fontsize',titlefontsize)

% turn off axis box
box off;

% get current axis
ha = gca;

% turn off both axises
ha.XColor = 'none';
ha.YColor = 'none';

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