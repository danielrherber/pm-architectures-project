%--------------------------------------------------------------------------
% plotDesignMatlab.m
% Custom plotting function using builtin Matlab functions
% Particularly useful for unconnected graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------
function plotDesignMatlab(A,L,i,pm,opts)

	% create a new figure and save handle
    hf = figure;
    
	% change the figure background
    hf.Color = [1 1 1];

    % create graph object   
    G = graph(A);
    
    % graph plot    
    h = plot(G,'k','NodeLabel',L,'MarkerSize',26); 
    
    % get color spec
    for k = 1:numel(L)
        c(k,:) = mycolorstr(L{k});
    end
    
    % get unique data for the labels
    [~,ia1,ic1] = unique(base2dec(L,36));
    
    % set colormap
    colormap(c(ia1,:));
    
    % add node colors
    h.NodeCData = ic1;
    
    % change marker size
    h.MarkerSize = 24;
    
    % change connection width
    h.LineWidth = 2;
    
    % add title
    title(['\textsl{PM ',num2str(pm),'}'],'Interpreter','latex', 'fontsize', 24)

    % turn off axis box
    box off;
    
    % turn off x-axis
    set(gca,'xcolor',get(gcf,'color'));
    set(gca,'xtick',[]);
    
    % turn off y-axis
    set(gca,'ycolor',get(gcf,'color'));
    set(gca,'ytick',[]);
        
    if opts.saveflag
        figname = ['graph',num2str(i)]; % name the figure
        % foldername = opts.path; % name the folder the figure will be placed in
        exportfigopts = '-png'; % export_fig options (see documentation)
        % exportfigopts = '-tif -nocrop -append'; % export_fig options (see documentation)
        % mypath2 = mfoldername(mfilename('fullpath'),foldername); % folder string
        filename = [opts.path,figname]; % combine folder string and name string
        str = ['export_fig ''',filename,''' ',exportfigopts]; % total str for export_fig
        eval(str) % evaluate and save the figure

        close(hf)
    end
    
end