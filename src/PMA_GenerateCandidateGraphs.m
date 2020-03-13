%--------------------------------------------------------------------------
% PMA_GenerateCandidateGraphs.m
% Generate candidate graphs with the specific approach
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [CandidateGraphs,I,N] = PMA_GenerateCandidateGraphs(L,R,P,opts,Np,Nc,ports)

% extract
displevel = opts.displevel;

% output some stats to the command window
if (displevel > 1) % verbose
    disp([num2str(2^(Nc*(Nc-1)/2)),' adjacency matrices using 2^(Nc*(Nc-1)/2)'])
    disp([num2str(prod(1:2:Np-1)), ' perfect matchings using (Np-1)!! method'])
    [L,~] = PMA_CalcUniqueGraphBnds(P,R);
    disp(['At least ',num2str(floor(L)),' unique graphs for (L,R,P) using Eqn. (12)'])
end

% check if catalog has no ports
if ~any(P)
    % return single graph
    CandidateGraphs = zeros(1,0); % no edges
    I = 0; % no perfect matching
    N = 1; % single graph
    return
end

% select the desired algorithm to generate candidate graphs
switch opts.algorithm
    %------------------------------------------------------------------
    case 'pm_incomplete'
        % random perfect matching numbers
        I = randi(prod(1:2:Np-1),opts.Nmax,1);

        % generate candidate graphs for some perfect matchings
        CandidateGraphs = PM_index2pm(I,Np);

        % number of graphs
        N = length(I);
    %------------------------------------------------------------------
    case 'pm_full'
        % generate all perfect matchings
        CandidateGraphs = PM_perfectMatchings(Np);

        % number of graphs
        N = prod(1:2:Np-1); % (N-1)!!

        % perfect matching numbers
        I = 1:N;
    %------------------------------------------------------------------
    otherwise
        % generate all candidate graphs using a tree algorithm
        [CandidateGraphs,I,N] = PMA_TreeGather(ports.labels.N,P,R,ports.NSC,opts,ports.phi);
end

% output some stats to the command window
if (displevel > 0) % minimal
    ttime = toc; % stop timer
    disp(['Generated ',num2str(N), ' candidate matchings with ',...
        opts.algorithm,' option in ', num2str(ttime),' s'])
end

end