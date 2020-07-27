%--------------------------------------------------------------------------
% PMA_DetectCycle.m
% Given undirected graph adjacency matrix, determine if a cycle is present
% Code modified from MFX 29438
%--------------------------------------------------------------------------
% From https://www.mathworks.com/matlabcentral/fileexchange/29438
% Algorithm is guaranteed to find each cycle exactly once.  It
%   is essentially equivalent to Johnson (SIAM J. Comput. (1975),
%   4, 77), but for undirected graphs, and without the look-ahead
%   feature.  The lack of look-ahead is expected to have
%   negligible performance impact on dense random graphs.
% Copyright (c) 2011, J. Jeffry Howbert and Laboratory for
%   Experimental Combinatorics.  All rights reserved.
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function cycleFlag = PMA_DetectCycle(A)

% change data type
A = logical(full(A));

% number of vertices
nVert = size(A,1);

% set limit size to maximum
limit = nVert;

% initialize cycle flag
cycleFlag = false;

% Generate all unique triples of connected vertices which have indices
% v1 < v2 < v3 and connections v2 - v1 - v3, then search for paths
% which connect v2 to v3
for ix = 1:nVert-2 % v1
    for jx = ix+1:nVert-1 % v2
        if A(ix,jx)
            inclVert = [zeros(1,ix), ones(1,nVert-ix)];
            inclVert(jx) = 0;
            for kx = jx+1:nVert % v3
                if A(kx,ix)
                    % initial path length = 2; now look for extensions
                    cycleFlag = nextVert(inclVert, 2, jx, kx, limit, A, cycleFlag);
                    if cycleFlag % stop if cycle found
                        return
                    end
                end
            end
        end
    end
end
end

% extend current path by one additional vertex
function cycleFlag = nextVert(inclVert, len, origin, target, limit, A, cycleFlag)

% increase length by one
len = len + 1;

% get candidates for extension
cand = find(inclVert.*A(origin,:));
for mx = 1:size(cand,2)
    ca = cand(mx);
    if (ca == target) % found a cycle
        cycleFlag = true;
        return
    elseif (len < limit) % extend again
        inclVert1 = inclVert;
        inclVert1(ca) = 0; % block vertex just added to path
        cycleFlag = nextVert(inclVert1, len, ca, target , limit, A, cycleFlag);
        if cycleFlag % stop if cycle found
            return
        end
    end
end
end

% % https://math.stackexchange.com/questions/910931/determine-cycle-from-adjacency-matrix/911040#911040
% L = diag(sum(A))- logical(A);
% if trace(L) >= 2*rank(L,0.1) + 2
%     cycleFlag = true;
% else
%     cycleFlag = false;
% end
% return