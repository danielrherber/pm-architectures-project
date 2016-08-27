function [pp,A,unusefulFlag] = ex_Suspension_Extra_Constraints(pp,A,unusefulFlag)
    %% parallel connection check
    if unusefulFlag ~= 1 % only if the graph is currently feasible
        MyKeep = [];
        temp = strcmp(pp.labels.C,'s');
        MyKeep = [MyKeep,find(temp)] ;
        temp = strcmp(pp.labels.C,'u');
        MyKeep = [MyKeep,find(temp)] ;
        temp = strcmp(pp.labels.C,'p');
        MyKeep = [MyKeep,find(temp)] ;
        MyA = A(MyKeep,MyKeep);
        W = ConnectivityMatrix(MyA,20);
        if W(1,2) == 1;
            unusefulFlag = 1;
        end
    end

    %% check for parallel cycles
    if unusefulFlag ~= 1 % only if the graph is currently feasible
        pIndex = find(strcmp(pp.labels.C,'p'));
        for k = pIndex % for each parallel connection
            otherIndex = setdiff(pIndex,k);
            myA = A; % temporary adjacency matrix (connected components)
            myA(:,otherIndex) = 0; % remove other parallel components
            myA(otherIndex,:) = 0; % remove other parallel components
            [cycleCount] = custom_cycleCountBacktrack('adjMatrix',myA); % check for cycles
            if sum(cycleCount) ~= 0 % if there are any cycles, graph is infeasible
                unusefulFlag = 1;
            end
        end    
    end

    %% modify graphs for interchangeable series components
    if unusefulFlag ~= 1 % only if the graph is currently feasible
        while 1
            I = find(pp.NCS.Vfull==2); % find 2-port components
            [row,col] = find(A(:,I)); % find row location of connections to 2-port components
            J = find(pp.NCS.Vfull(row)==2,1,'first'); % find first connection with another 2-port component
            if isempty(J)
                break % no more 2-2 connections, leave loop
            else
                keep = min(I(col(J)),row(J)); % keep the smallest index
                remove = max(I(col(J)),row(J)); % remove the largest index
                % modify adjacency matrix
                A(:,keep) = A(:,keep) + A(:,remove); % combine connections
                A(keep,:) = A(keep,:) + A(remove,:); % combine connections
                A(:,remove) = []; %  remove component
                A(remove,:) = []; % remove component
                A = A  - diag(diag(A)); % remove diagonal entries
                % the diagonal entry is always present in this procedure
                % generate the new colored label
                newlabel = [pp.labels.C{keep},pp.labels.C{remove}]; % combine previous
                newlabel = sort(newlabel); % sort for uniqueness
                pp.labels.C{keep} = newlabel; % assign new label
                pp.labels.C(remove) = []; % remove old label
                % hash the string label (convert the characters to numbers)
                
                str = double(newlabel); % string of numbers with spaces
                str(str==107) = 6;
                str(str==98) = 7;
                str(str==102) = 8;
                str = num2str(str);
                str(ismember(str,' ')) = []; % remove the spaces
                pp.labels.N(keep) = str2double(['99',str]); % assign new number
                pp.labels.N(remove) = []; % remove old number
                % remove old counts entry
                pp.NCS.Vfull(remove) = []; 
                % the keep entry is the same as before (2)
            end % end if isempty(J)
        end % end while 1
    end % end if unusefulFlag ~= 1

end

function cycleCount = custom_cycleCountBacktrack( inputFormat, source, varargin )
% cycleCountBacktrack: Count all cycles in input graph up to specified
%   size limit, using backtracking algorithm.  Designed for undirected
%   graphs with no self-loops or multiple edges.
%
% usage: cycleCountBacktrack( inputFormat, source [, limit ] )
%
% input arguments:
%   inputFormat, source - Enter 'help readGraph' for information on
%       supported input formats.
%   limit (optional) - type: integer. Specifies largest cycle size to
%       search for and count.
%
% output arguments:
%   cycleCount - type: vector of integers (as doubles).  Holds counts
%       of cycles for each size cycle from 3 up to limit.
%   elapsedTime - type: double.  Elapsed time for computation of cycle
%       counts, in seconds.
%
% Algorithm is guaranteed to find each cycle exactly once.  It
%   is essentially equivalent to Johnson (SIAM J. Comput. (1975),
%   4, 77), but for undirected graphs, and without the look-ahead
%   feature.  The lack of look-ahead is expected to have
%   negligible performance impact on dense random graphs.
%
% Sample source files for each inputFormat are included with
%   this code.
%
% Copyright (c) 2011, J. Jeffry Howbert and Laboratory for 
%   Experimental Combinatorics.  All rights reserved.
% Version 1.1             Aug. 27, 2011
%
    global A limit cycleCount
    
    A = readGraph( inputFormat, source );

    nVert = size( A, 1 );

    if ( size( varargin ) >= 1 & isnumeric( varargin{ 1 } ) )
        limit = floor( varargin{ 1 } );
        if ( limit < 3 )
            limit = 3;
        elseif ( limit > size( A, 1 ) )
            limit = size( A, 1 );
        end
    else
        limit = size( A, 1 );
    end
    
    cycleCount = zeros( 1, nVert );

    % Generate all unique triples of connected vertices which have
    %   indices v1 < v2 < v3 and connections v2 - v1 - v3, then 
    %   search for paths which connect v2 to v3
    for ix = 1 : nVert - 2                    % v1
        for jx = ix + 1 : nVert - 1           % v2
            if ( A( ix, jx ) == 1 )
                inclVert = [ zeros( 1, ix ), ones( 1, nVert - ix ) ];
                inclVert( jx ) = 0;
                for kx = jx + 1 : nVert       % v3
                    if ( A( kx, ix ) == 1 )
                        % initial path length = 2; now look for extensions
                        nextVert( inclVert, 2, jx, kx );  
                    end
                end
            end
        end
    end
    
    cycleCount = cycleCount( 3 : limit );   % return counts

end         % function cycleCountBacktrack

% extend current path by one additional vertex
function nextVert( inclVert, len, origin, target )
    % input arguments:
    %   inclVert - type: vector of 0's and 1's.  1's specify
    %       vertices available for extension of current path;
    %       0's indicate vertices blocked because they have
    %       lower index than v1, or are already on current
    %       path.
    %   len - type: integer.  Length of current path.
    %   origin - type: integer.  Vertex at growing terminus
    %       of current path.
    %   target - type: integer.  Vertex at start of path (v3).
    global A limit cycleCount;
    len = len + 1;
    % get candidates for extension
    cand = find( inclVert .* A( origin, : ) );
    for mx = 1 : size( cand, 2 )
        ca = cand( mx );
        if ( ca == target )         % found a cycle
            cycleCount( len ) = cycleCount( len ) + 1;
        elseif ( len < limit )      % extend again
            inclVert1 = inclVert;
            inclVert1( ca ) = 0;    % block vertex just added to path 
            nextVert( inclVert1, len, ca, target );
        end
    end
end     % function nextVert