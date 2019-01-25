%--------------------------------------------------------------------------
% PMA_GenerateCandidateGraphs.m
% Generate candidate graphs with the specific algorithm
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [CandidateGraphs,I,N] = PMA_GenerateCandidateGraphs(C,R,P,opts,Np,Nc,ports)

    % output some stats to the command window
    if (opts.displevel > 1) % verbose
        disp([num2str(2^(Nc*(Nc-1)/2)),' adjacency matrices using 2^(Nc*(Nc-1)/2)'])
        disp([num2str(prod(1:2:Np-1)), ' perfect matchings using (Np-1)!! method'])
        [L,~] = PMA_CalcUniqueGraphBnds(P,R);
        disp(['At least ',num2str(floor(L)),' unique graphs for (C,R,P) using Eqn. (12)'])
    end

    % select the desired algorithm to generate candidate graphs
    switch opts.algorithm
        
        case 'pm_incomplete'
            I = randi(prod(1:2:Np-1),opts.Nmax,1);
            CandidateGraphs = PM_index2pm(I,Np); % some of the perfect matchings

        case 'pm_full'     
            N = prod(1:2:Np-1); % (N-1)!! architectures
            I = 1:N;
            CandidateGraphs = PM_perfectMatchings(Np); % generate all perfect matchings

        otherwise
            [CandidateGraphs,I,N] = PMA_TreeGather(ports.labels.N,P,R,ports.NSC,opts,ports.phi);
    end

    % output some stats to the command window
    if (opts.displevel > 0) % minimal
        ttime = toc; % stop timer
        disp(['Generated ',num2str(N), ' candidate matchings with ',opts.algorithm,' option in ', num2str(ttime),' s'])
    end

end