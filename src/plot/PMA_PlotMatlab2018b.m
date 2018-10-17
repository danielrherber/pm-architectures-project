%--------------------------------------------------------------------------
% PMA_PlotMatlab2018b.m
% Custom plotting function using built-in Matlab functions
% Particularly useful for unconnected graphs
% Syntax used is only available in r2018b
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
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

    % get color spec
    c = zeros(length(L),3);
    for k = 1:numel(L)
        c(k,:) = MyColorValues(L{k});
    end

	% create a new figure and save handle
    hf = figure;
    hf.Color = [1 1 1]; % change the figure background

    % create undirected graph object   
    G = graph(A);

    % graph plot
    if any(A(:) > 1) % check if multiedges are present
        [~,~,V] = find(tril(A));
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
    for idx = 1:length(L)
        text(X(idx),Y(idx)-yshift,['\textsl{',L{idx},'}'],...
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

    if opts.saveflag
        figname = ['graph',num2str(I)]; % name the figure
        % foldername = opts.path; % name the folder the figure will be placed in
        exportfigopts = '-png'; % export_fig options (see documentation)
        % exportfigopts = '-tif -nocrop -append'; % export_fig options (see documentation)
        % mypath2 = mfoldername(mfilename('fullpath'),foldername); % folder string
        filename = [opts.path,figname]; % combine folder string and name string
        str = ['export_fig ''',filename,''' ',exportfigopts]; % total str for export_fig
        eval(str) % evaluate and save the figure
        close(hf) % close the figure
    end

end