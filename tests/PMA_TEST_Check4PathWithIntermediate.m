%--------------------------------------------------------------------------
% PMA_TEST_Check4PathWithIntermediate.m
% Test function for PMA_Check4PathWithIntermediate
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

% test number
num = 1;

switch num
    %----------------------------------------------------------------------
    case 1 % should find a path
    rng(1)
    n = 10;
    p = 0.2;
    A = rand(n)<p;
    A = logical(A+A');
    G = graph(A);
    plot(G)
    S = 1; % start node
    E = 2; % end node
    I = 3; % intermediate node
    %----------------------------------------------------------------------
    case 2 % should not find a path
    rng(15345)
    n = 10;
    p = 0.2;
    A = rand(n)<p;
    A = logical(A+A');
    G = graph(A);
    plot(G)
    S = 7; % start node
    E = 10; % end node
    I = 1; % intermediate node
    %----------------------------------------------------------------------
    case 3 % should find a path
    rng(1)
    n = 100;
    p = 0.01;
    A = rand(n)<p;
    A = logical(A+A');
    G = graph(A);
    plot(G)
    S = 60; % start node
    E = 98; % end node
    I = 77; % intermediate node
    %----------------------------------------------------------------------
    case 4 % should not find a path
    rng(1)
    n = 20;
    p = 0.05;
    A = rand(n)<p;
    A = logical(A+A');
    G = graph(A);
    plot(G)
    S = 4; % start node
    E = 9; % end node
    I = 16; % intermediate node
    %----------------------------------------------------------------------
end

% run the test
flag = PMA_Check4PathWithIntermediate(A,S,E,I);

disp(flag)
