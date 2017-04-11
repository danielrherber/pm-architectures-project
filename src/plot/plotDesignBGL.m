%--------------------------------------------------------------------------
% plotDesignBGL.m
% Custom plotting function using a force directed layout
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------

function plotDesignBGL(A,L,i,pm,opts)

A = sparse(A);

xy = kamada_kawai_spring_layout(A,'spring_constant',1e-2,'tol',1e-10);
% normalize layout
xy(:,1) = (xy(:,1)-min(xy(:,1)))./(max(xy(:,1)) - min(xy(:,1)));
xy(:,2) = (xy(:,2)-min(xy(:,2)))./(max(xy(:,2)) - min(xy(:,2)));
xy = 2*xy - 1;


% A = sparse(A);

n = length(A);
% theta = ( (0:n-1)'*360/n + 90 )*pi/180;
% 
r = 0.3;
% xy(:,1) = cos(theta);
% xy(:,2) = sin(theta);

h = figure; clf

in.labelsca = [];
in.markersize = 0.001; in.fontsize = 100; in.linewidth = 4;
% in.nodecolor = 'w'; in.edgecolor = [0.2 0.2 0.2]; in.edgestyle = '-';
in.nodecolor = 'w'; in.edgecolor = [0 0 0]; in.edgestyle = '-';
mygplotwl(A,xy,in); hold on

for j = 1:n
    c = MyColorValues(L{j});
            
    x = xy(j,1);
    y = xy(j,2);
    rectangle('Position',[x-r/2 y-r/2 r r],'Curvature',[1 1],...
        'FaceColor',tint(c,0.85),'EdgeColor',c,'Linewidth',4); hold on
    text(x,y-0.02,['\textsl{',L{j},'}'],'HorizontalAlignment','center',...
        'Interpreter','latex', 'fontsize', 24)
%     annotation('textbox',[x-r/2 y-r/2 r r],'String',L(i),'FitBoxToText','on');
end

xlim([-1.2 1.2]); ylim([-1.2 1.2]); 
axis equal
set(gcf,'color','white'); axis off

text(0,-1.35,['\textsl{PM ',num2str(pm),'}'],'HorizontalAlignment','center',...
        'Interpreter','latex', 'fontsize', 32)

if opts.saveflag
    % figname = ['graph',num2str(i)]; % name the figure
    figname = 'graphs'; % name the figure
    % foldername = opts.path; % name the folder the figure will be placed in
    exportfigopts = '-pdf -append'; % export_fig options (see documentation)
    % exportfigopts = '-tif -nocrop -append'; % export_fig options (see documentation)
    % mypath2 = mfoldername(mfilename('fullpath'),foldername); % folder string
    filename = [opts.path,figname]; % combine folder string and name string
    str = ['export_fig ''',filename,''' ',exportfigopts]; % total str for export_fig
    eval(str) % evaluate and save the figure

    close(h)
end

end