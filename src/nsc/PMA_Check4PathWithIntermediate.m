%--------------------------------------------------------------------------
% PMA_Check4PathWithIntermediate.m
% Check if there exists a path between a defined start and end node that
% contains a specified intermediate node
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function flag = PMA_Check4PathWithIntermediate(A,S,E,I)

% remove loops
A = A - diag(diag(A));

% list of all vertices that should be in the path
V = [S,E,I];

% initialize all vertices untouched
T = ones(1,length(A));

% current vertex
C = S;

% remove starting vertex
T(C) = 0;

% try to find the path
[flag,~] = Check4PathWithIntermediate(T,C,A,V);

end

% subfunction
function [flag,path] = Check4PathWithIntermediate(T,C,A,V)

flag = false; % path not found
path = []; % no path

% check if both S and E are in the path but not I
if all(T(V) == [0 0 1])
    flag = false; % not a valid path
    path = [];
    return
end

% check if all vertices are in the path
if all(T(V) == [0 0 0])
    flag = true; % path found
    path = find(~T); % not properly ordered
    return
end

% find all vertices connected to current vertex
Icon = find(A(C,:));

% remove all connections to current vertex
A(C,:) = 0; A(:,C) = 0;

% go through potential connection
for c = Icon

    % local copy
    t = T;

    % add node to path
    t(c) = 0;

    % iterate
    [flag,path] = Check4PathWithIntermediate(t,c,A,V);

    % stop if path found
    if flag
        return
    end
end

end