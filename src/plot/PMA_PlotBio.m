%--------------------------------------------------------------------------
% PMA_PlotBio.m
% Custom plotting function using the biograph viewer
% Particularly useful for unconnected graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function PMA_PlotBio(A,L,PM,I,opts)

% add numbers to each replicate
% find the indices for the different component types
[C,~,IC] = unique(L,'stable');
N = histcounts(IC);

% add numbers to the labels
Lnum = cell(length(C),1);
for idx = 1:length(C)
    Lnum{idx} = strcat(C{idx},string(1:N(idx)));
end
Lnum = horzcat(Lnum{:});

% make biograph object
bg = biograph(tril(A,-1),Lnum);

% customize
bg.ShowArrows = 'off';
bg.LayoutScale = 0.5;
bg.LayoutType = 'equilibrium';

% calculate node positions and edge trajectories
dolayout(bg);

% view the plot
view(bg);
end