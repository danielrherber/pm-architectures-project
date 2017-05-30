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
function plotDesign(UniqueFeasibleGraphs,NSC,opts)

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
            Nplot = min(opts.plotmax,length(UniqueFeasibleGraphs));
        else
            Nplot = length(UniqueFeasibleGraphs);
        end
        
        % generate the desired plot type
        switch lower(opts.plotfun)
            %--------------------------------------------------------------
            case 'bio'
                for i = 1:Nplot
                    plotDesignBio(UniqueFeasibleGraphs(i).A,...
                        UniqueFeasibleGraphs(i).L)
                end    
            %--------------------------------------------------------------
            case 'bgl'
                for i = 1:Nplot
                    plotDesignBGL(UniqueFeasibleGraphs(i).A,...
                        UniqueFeasibleGraphs(i).L,i,UniqueFeasibleGraphs(i).N,opts)
                end
            %--------------------------------------------------------------
            case 'circle'
                for i = 1:Nplot
                    plotDesignCircle(UniqueFeasibleGraphs(i).A,...
                        UniqueFeasibleGraphs(i).L,i,UniqueFeasibleGraphs(i).N,opts)
                end
            %--------------------------------------------------------------
            case 'matlab'
                for i = 1:Nplot
                    plotDesignMatlab(UniqueFeasibleGraphs(i).A,...
                        UniqueFeasibleGraphs(i).L,i,UniqueFeasibleGraphs(i).N,opts)
                end    
            %--------------------------------------------------------------
        end

    end
end
