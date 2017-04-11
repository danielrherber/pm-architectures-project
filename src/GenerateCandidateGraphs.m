%--------------------------------------------------------------------------
% GenerateCandidateGraphs.m
% Generate candidate graphs with the specific algorithm
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [CandidateGraphs,I,N] = GenerateCandidateGraphs(C,R,P,opts,Np,Nc,ports)

    % select the desired algorithm to generate candidate graphs
    switch opts.algorithm
        
        case 'pm_incomplete'
            I = randi(prod(1:2:Np-1),opts.Nmax,1);
            CandidateGraphs = SinglePerfectMatchings(I,Np); % some of the perfect matchings

        case 'pm_full'     
            N = prod(1:2:Np-1); % (N-1)!! architectures
            I = 1:N;
            CandidateGraphs = PerfectMatchings(Np); % generate all perfect matchings

        case {'tree','tree_v1','tree_v2','tree_v3','tree_v4','tree_v5',...
                'tree_v6','tree_v7','tree_v8',...
                'tree_v1_analysis','tree_v2_analysis','tree_v3_analysis',...
                'tree_v5_analysis'}
            opts.limited = 0;
            [CandidateGraphs,I,N] = TreeEnumerateGather(C,P,R,ports.labels.N,ports.NSC,opts);

        case 'treelimited'
            opts.limited = 1;
            [CandidateGraphs,I,N] = TreeEnumerateGather(ports.NSC.counts,ports.NSC.A,R,opts);

        case 'treelimitedincomplete'
            [CandidateGraphs,I,N] = TreeExploreGather(ports.NSC.counts,ports.NSC.A,R,opts,opts.Nmax);
            
    end

    % output some stats to the command window
    if (opts.displevel > 1) % verbose
        disp([num2str(2^(Nc*(Nc-1)/2)),' adjacency matrices, 2^(Nc*(Nc-1)/2) method'])
        disp([num2str(prod(1:2:Np-1)), ' perfect matchings, (Np-1)!! method'])
    end
    if (opts.displevel > 0) % minimal
        ttime = toc; % stop timer
        disp(['Generated ',num2str(N), ' candidate matchings with ',opts.algorithm,' option in ', num2str(ttime),' s'])
    end

end