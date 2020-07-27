%--------------------------------------------------------------------------
% PMA_TEST_PlotMatlab.m
% Test for PMA_PlotMatlab
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
clear; clc; close all; closeallbio;

L = {'A','B','B','B','C','C','C','D','D'};
% L = {'G','L','L','L','o','o','o','P','P'}; % other labels
% L = {'R','X','X','X','Y','Y','Y','Z','Z'}; % other labels

A = zeros(length(L));
A(1,1) = 2; % A1-A1
A(1,2) = 2; % A1-B1
A(2,3) = 1; % B1-B2
A(3,3) = 1; % B2-B2
A(4,6) = 1; % B3-C2
A(4,7) = 1; % B3-C3
A(4,9) = 1; % B3-D2
A(1,5) = 1; % A1-C1
A(5,8) = 1; % C1-D1
A(6,7) = 1; % C2-C3
A = (A+A') - diag(diag(A));

% options
opts.saveflag = 0;
opts.labelnumflag = true;
opts.colorlib = 1;

% no multi-edges
PMA_PlotMatlab(A>0,L,1,nan,opts)

% multi-edges
PMA_PlotMatlab(A,L,1,nan,opts)