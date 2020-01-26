%--------------------------------------------------------------------------
% PMA_EnumerationAlg_v10_test.m
% Test function for PMA_EnumerationAlg_v10
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function PMA_EnumerationAlg_v10_test

% display level
displevellocal = 0;

% inputs
cVf = uint8([2    3    4    6    8   11   15]);
Vf = uint8([1   1   1   2   2   3   4]);
iInitRep = uint8([1;2;4;6;7]);
phi = uint16([1   2   3   4   4   5   5   6   6   6   7   7   7   7]);
counts = uint8([0   0   0   0   0   0   0]);
A = ones(7,'uint8');
Bflag = false;
B = zeros(0,'uint8');
Mflag = false;
M = uint8([0   0   0   0   0   0   0]);
Pflag = true;
Iflag = false;
Imethod = uint8(2);
IN = uint64(100);
Ln = [25    27    27    16    16    11    24];
Nmax = uint64(270270);
displevel = uint8(2);

% start timer
tic

% original
output1 = PMA_EnumerationAlg_v10(cVf,Vf,iInitRep,phi,counts,...
    A,Bflag,B,Mflag,M,Pflag,Iflag,Imethod,IN,Ln,Nmax,displevel);
if displevellocal, toc, end

% mex version
try
    % run mex version
    tic
    output2 = PMA_EnumerationAlg_v10_mex(cVf,Vf,iInitRep,phi,counts,...
    A,Bflag,B,Mflag,M,Pflag,Iflag,Imethod,IN,Ln,Nmax,displevel);
    if displevellocal, toc, end

    % tests
    if isequal(output1,output2)
        c1 = 'passed';
    else
        c1 = 'failed';
    end

    % display
    disp(['test 1 status: ',c1])

catch
    error('mex version failed')
end

end