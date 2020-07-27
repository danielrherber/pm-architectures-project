%--------------------------------------------------------------------------
% PMA_PlotGraphs.m
% Plots a set of labeled graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function PMA_PlotGraphs(G,NSC,opts)

% extract plot options
plots = opts.plots;

if isfield(plots,'plotfun')

    % determine if matlab plots are needed
    if (~NSC.connected) && strcmpi(plots.plotfun,'bgl')
        if (opts.displevel > 1) % verbose
            warning('switching to ''matlab'' since there may be incomplete graphs')
        end
        plots.plotfun = 'matlab';
    end

    % determine how many graphs to plot
    if isfield(plots,'plotmax')
        Nplot = min(plots.plotmax,length(G));
    else
        Nplot = length(G);
    end

    % select the desired plot function
    switch lower(plots.plotfun)
        case 'matlab'
            PlotFun = @PMA_PlotMatlab;
        case 'matlab2018b'
            PlotFun = @PMA_PlotMatlab2018b;
        case 'circle'
            PlotFun = @PMA_PlotCircle;
        case 'bio'
            PlotFun = @PMA_PlotBio;
        case 'bgl'
            PlotFun = @PMA_PlotBGL;
    end

    % (potentially) randomize plot ordering
    if isfield(plots,'randomize')
        if plots.randomize
            G = G(randperm(length(G)));
        end
    end

    % plot each graph
    for idx = 1:Nplot
        PlotFun(G(idx).A,G(idx).L,G(idx).N,idx,plots);
    end

end
end