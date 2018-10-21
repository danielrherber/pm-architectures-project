%--------------------------------------------------------------------------
% PMA_PlotTreeEnumerate.m
% Visualize tree algorithm
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------

set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter

% get all first column elements of M
A = M(:,1);

% find the first zero row in M
k = find(~A,1);

% extract the nonzero rows of M
if ~isempty(k)
    M = M(1:k-1,:); 
end

figure('Color',[1 1 1],'Position', [100, 100, 1100, 200]);
treeplot(nodelist); hold on
h = gcf;
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children');

if length(dataObjs) == 2
    dataObjs(2).Marker = 'none';
end
dataObjs(1).Color = [0 0 0];

% scale X data
X = dataObjs(1).XData;
X = (X-min(X))/(max(X)-min(X));
dataObjs(1).XData = (length(M)-1)*X + 1;
xlim([0 length(M)+1])

% scale Y data
Np = sum(Vfull);
Y = dataObjs(1).YData;
Y = (Y-min(Y))/(max(Y)-min(Y));
dataObjs(1).YData = Np/2*Y;

ylim([0 Np/2])

for i = 1:Np/2+1
    yticks{i} = ['$',num2str(i-1),'$'];
end

myfont2 = 12;

% [hx,hy] = format_ticks_v2(gca,[],yticks,...
%     [],0:1:Np/2,[],[],[],0.006);
% set(hy,'fontsize',myfont2)
% ylabh = get(gca,'YLabel');
% set(ylabh,'Position',get(ylabh,'Position') - [20 0 0])
% % set(ylabh,'Position',get(ylabh,'Position') - [1.5 0 0])
% delete(hx)

for i = 1:Np/2+1
    xticks{i} = ['$',num2str(i-1),'$'];
end


% [hx,hy] = format_ticks_v2(gca,{'$2$','$6$','$10$','$20$','$30$','$40$'},[],...
%     0:Np/2,[],[],[],[],0.006);
% set(hx,'fontsize',myfont2)
% xlabh = get(gca,'XLabel');
% set(xlabh,'Position',get(xlabh,'Position') - [0 0.5 0])

ax = gca;
ax.XColor = [0.5 0.5 0.5];
ax.YColor = [0.5 0.5 0.5];
ax.Layer = 'top';

ylabel('Edges Available','interpreter','latex','fontsize',myfont2,'Color',[0 0 0])
xlabel('','interpreter','latex','fontsize',myfont2)

set(gca,'xtick',[])
set(gca,'xticklabel',[])

figname = 'TreeEnumerate'; % name the figure
% foldername = opts.path; % name the folder the figure will be placed in
exportfigopts = '-png -pdf'; % export_fig options (see documentation)
% exportfigopts = '-tif -nocrop -append'; % export_fig options (see documentation)
% mypath2 = mfoldername(mfilename('fullpath'),foldername); % folder string
filename = [opts.path,figname]; % combine folder string and name string
str = ['export_fig ''',filename,''' ',exportfigopts]; % total str for export_fig
eval(str) % evaluate and save the figure

% close(h)