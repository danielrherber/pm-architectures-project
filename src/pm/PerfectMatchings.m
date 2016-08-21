%--------------------------------------------------------------------------
% PerfectMatchings.m
% Applies a recursive algorithm to list all the perfect matchings of a 
% complete graph
%--------------------------------------------------------------------------
% A = PerfectMatchings(N,varargin)
% N           : number of vertices (should be even)
% varargin{1} : if present, should be a structure of perfect matchings
% A           : matrix of perfect matchings grouped in sequential pairs
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 07/27/2015
% http://www.mathworks.com/matlabcentral/fileexchange/52301
%--------------------------------------------------------------------------
function  A = PerfectMatchings(N,varargin)
    if N == 2
        A = uint8([2 1]);
        return
    end
    if isempty(varargin) % check if P is present
        P(N).A = []; % initialize structure
        P(2).A = uint8([2 1]); % perfect matchings of K2
    else
        P = varargin{1}; % assign previously found perfect matchings
    end
    % find the list of perfect matchings with the recursive algorithm
    A = SubMatchings(uint8(1:N),P);
return
%--------------------------------------------------------------------------
% A = SubMatchings(V,P)
% V : list of available vertices 
% P : structure containing previously found perfect matchings
% A : matrix of perfect matchings
%--------------------------------------------------------------------------
function A = SubMatchings(V,P)
    N = length(V); % number of vertices
    NN = prod(1:2:N-3); % number of repetitions, (N-2)!!
    for j = N-1:-1:1
        v = V; % local list of vertices
        C = [v(N)*ones(NN,1,'uint8') v(j)*ones(NN,1,'uint8')]; % repeat this connection
        v(N) = []; % remove largest remaining value
        v(j) = []; % remove the selected value    
        if isempty(P(N-2).A) % does the K_{N-2} perfect matchings matrix exist?
            P(N-2).A = SubMatchings(uint8(1:N-2),P); % find the perfect matchings, recursive
        end
        D = v(P(N-2).A); % sort remaining vertices with previous perfect matchings  
        A(NN*(j-1)+1:NN*(j),:) = [C D]; % add to matrix of perfect matchings
    end
return