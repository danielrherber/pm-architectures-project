%--------------------------------------------------------------------------
% PMA_EnumerationAlg_v1_test.m
% Test function for PMA_EnumerationAlg_v1
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function PMA_EnumerationAlg_v1_test

% display level
displevellocal = 0;

% inputs
V = uint8([1   1   1   2   2   3   4]);
E = zeros(0,'uint8');
SavedGraphs = zeros(270270,14,'uint8');
id = uint64(0);
cVf = uint8([2    3    4    6    8   11   15]);
A = ones(7,'uint8');
displevel = uint8(1);

% start timer
tic

% original
[output11,output12] = PMA_EnumerationAlg_v1(V,E,SavedGraphs,id,cVf,A,displevel);
if displevellocal, toc, end

% mex version
try
    % run mex version
    tic
    [output21,output22] = PMA_EnumerationAlg_v1_mex(V,E,SavedGraphs,id,cVf,A,displevel);
    if displevellocal, toc, end

    % tests
    if isequal(output11,output21)
        c1 = 'passed';
    else
        c1 = 'failed';
    end

    % display
    disp(['test 1 status: ',c1])

    % tests
    if isequal(output12,output22)
        c2 = 'passed';
    else
        c2 = 'failed';
    end

    % display
    disp(['test 2 status: ',c2])

catch
    error('mex version failed')
end

end