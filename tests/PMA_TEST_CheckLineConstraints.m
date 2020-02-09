%--------------------------------------------------------------------------
% PMA_TEST_CheckLineConstraints.m
% Test function for PMA_CheckLineConstraints
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% new label index sequence with old index numbers
ln = [2 1 4 5 5 5 6 7 7];

% some line-connectivity constraints
lineTriple = [];
lineTriple(end+1,:) = [1,5,2];
lineTriple(end+1,:) = [2,5,1];
lineTriple(end+1,:) = [5,6,7];
lineTriple(end+1,:) = [3,5,1];
lineTriple(end+1,:) = [2,5,3];
lineTriple(end+1,:) = [3,5,2];
lineTriple(end+1,:) = [1,5,5];
lineTriple(end+1,:) = [5,5,5];

% update the line-connectivity constraints
tic
lineTriple = PMA_ExtractLineConstraints(lineTriple,ln);
toc

disp(lineTriple)