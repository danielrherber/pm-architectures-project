%--------------------------------------------------------------------------
% UniqueUsefulGraphs.m
% Given an architecture problem, find the set of unique useful graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------
%% add files to path
% generate string of the folder name for this file
mypath1 = mfoldername(mfilename('fullpath'),'');
addpath(genpath(mypath1)); % add contents

%% generate candidate graphs (trimmed, feasible)
if ~exist('N','var'), N = []; end
Graphs = GenerateFeasibleGraphs(C,R,P,NCS,opts,N);

%% check for colored graph isomorphisms
[UniqueFeasibleGraphs,typearray] = RemovedColoredIsos(Graphs,opts);

%% plot the unique designs
if isfield(opts,'plotfun')
    % close all open figures
    closeallbio
    close all
    
    % determine if biograph plots are needed
    if (sum(NCS.necessary) == 0) && strcmp(opts.plotfun,'bgl')
        warning('switching to bio plot since there may be incomplete graphs')
        opts.plotfun = 'bio';
    end
    
    % determine how many graphs to plot
    if isfield(opts,'plotmax')
        Nplot = min(opts.plotmax,length(UniqueFeasibleGraphs));
    else
        Nplot = length(UniqueFeasibleGraphs);
    end
    
    switch opts.plotfun

        case 'bio'
            for i = 1:Nplot
                plotDesignBio(UniqueFeasibleGraphs{i}.A,UniqueFeasibleGraphs{i}.L)
            end
                        
        case 'bgl'
            for i = 1:Nplot
                plotDesignBGL(UniqueFeasibleGraphs{i}.A,UniqueFeasibleGraphs{i}.L,i,UniqueFeasibleGraphs{i}.N,opts)
            end
            
        case 'circle'
            for i = 1:Nplot
                plotDesignCircle(UniqueFeasibleGraphs{i}.A,UniqueFeasibleGraphs{i}.L,i,UniqueFeasibleGraphs{i}.N,opts)
            end

    end
    
end