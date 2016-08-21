%--------------------------------------------------------------------------
% GenerateCandidateGraphs.m
% Generate candidate graphs with the specific algorithm
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 08/20/2016
%--------------------------------------------------------------------------
function [M,I,N] = GenerateCandidateGraphs(R,P,opts,N,Np,Nc,ports)

    % select the desired algorithm to generate candidate graphs
    switch opts.algorithm
        
        case 'pm_incomplete'
            I = randi(prod(1:2:Np-1),N,1);
            M = SinglePerfectMatchings(I,Np); % some of the perfect matchings

        case 'pm_full'     
            N = prod(1:2:Np-1); % (N-1)!! architectures
            I = 1:N;
            M = PerfectMatchings(Np); % generate all perfect matchings

        case {'tree','tree_v1','tree_v2','tree_v3','tree_v4'...
                'tree_v1_analysis','tree_v2_analysis','tree_v3_analysis','tree_v4_analysis'}
            opts.limited = 0;
            [M,I,N] = TreeEnumerateGather(P,R,ports.NCS,opts);

        case 'treelimited'
            opts.limited = 1;
            [M,I,N] = TreeEnumerateGather(ports.NCS.counts,ports.NCS.A,R,opts);

        case 'treelimitedincomplete'
            [M,I,N] = TreeExploreGather(ports.NCS.counts,ports.NCS.A,R,opts,N);
            
    end

    % output some stats to the command window
    disp([num2str(2^(Nc*(Nc-1)/2)),' adjacency matrices, 2^(Nc*(Nc-1)/2) method'])
    disp([num2str(prod(1:2:Np-1)), ' perfect matchings, (Np-1)!! method'])
    disp(['Generated ',num2str(N), ' candidate matchings with ',opts.algorithm,' option'])

end