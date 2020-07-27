%--------------------------------------------------------------------------
% PMA_CheckLineConstraints.m
% Check line-connectivity constraints
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function feasibleFlag = PMA_CheckLineConstraints(Am,Bm,feasibleFlag)
% make full and correct data type
A = uint8(full(Am));

% find connections in lower triangular matrix
[I1,I2] = find(tril(A,-1));

% go through each connection
for k = 1:length(I1)

    % check #1-#2-#3
    B21 = Bm(:,I2(k),I1(k)); % find what is allowed after #1-#2
    A2 = A(I2(k),:)'; % find what #2 is connected to
    A2(I1(k)) = A2(I1(k)) - 1; % remove the current connection
    if any((2*B21 + A2) == 1) % check if infeasible edge exists
        feasibleFlag = false; % declare graph infeasible
        break % break for loop
    end

    % check #2-#1-#3
    B12 = Bm(:,I1(k),I2(k)); % find what is allowed after #1-#2
    A1 = A(I1(k),:)'; % find what #2 is connected to
    A1(I2(k)) = A1(I2(k)) - 1; % remove the current connection
    if any((2*B12 + A1) == 1) % check if infeasible edge exists
        feasibleFlag = false; % declare graph infeasible
        break % break for loop
    end

end

end
% logic
% if B21=0, A2=0; then 0 ok
% if B21=0, A2=1; then 1 infeasible since #1-#2-#3
% if B21=1, A2=0; then 2 ok
% if B21=1, A2=1; then 3 ok