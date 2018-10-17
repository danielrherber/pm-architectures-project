%--------------------------------------------------------------------------
% plotDesign.m
% Plots a set of colored graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function plotDesign(G,NSC,opts)

    if isfield(opts,'plotfun')
        % close all open figures
        closeallbio
        close all

        % determine if matlab plots are needed
        if (sum(NSC.M) == 0) && strcmp(opts.plotfun,'bgl')
            if (opts.displevel > 1) % verbose
                warning('switching to ''matlab'' since there may be incomplete graphs')
            end
            opts.plotfun = 'matlab';
        end

        % determine how many graphs to plot
        if isfield(opts,'plotmax')
            Nplot = min(opts.plotmax,length(G));
        else
            Nplot = length(G);
        end
        
        % generate the desired plot type
        switch lower(opts.plotfun)
            %--------------------------------------------------------------
            case 'matlab2018b'
                for idx = 1:Nplot
                    PMA_PlotMatlab2018b(G(idx).A,G(idx).L,G(idx).N,idx,opts)
                end   
            %--------------------------------------------------------------
            case 'bio'
                for idx = 1:Nplot
                    plotDesignBio(G(idx).A,...
                        G(idx).L)
                end    
            %--------------------------------------------------------------
            case 'bgl'
                for idx = 1:Nplot
                    plotDesignBGL(G(idx).A,...
                        G(idx).L,idx,G(idx).N,opts)
                end
            %--------------------------------------------------------------
            case 'circle'
                for idx = 1:Nplot
                    plotDesignCircle(G(idx).A,...
                        G(idx).L,idx,G(idx).N,opts)
                end
            %--------------------------------------------------------------
            case 'matlab'
                for idx = 1:Nplot
                    plotDesignMatlab(G(idx).A,G(idx).L,G(idx).N,idx,opts)
                end    
            %--------------------------------------------------------------
        end

    end
end
