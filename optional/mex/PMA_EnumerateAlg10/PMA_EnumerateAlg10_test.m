%--------------------------------------------------------------------------
% PMA_EnumerateAlg10_test.m
% Test function for PMA_EnumerateAlg10
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function PMA_EnumerateAlg10_test

% display level
displevel = 0;

% inputs
cVf = uint8([2    3    4    6    8   11   15]);
Vf = uint8([1   1   1   2   2   3   4]);
iInitRep = uint8([1;2;4;6;7]);
counts = uint8([0   0   0   0   0   0   0]);
phi = uint16([1   2   3   4   4   5   5   6   6   6   7   7   7   7]);
Ln = [25    27    27    16    16    11    24];
A = ones(7,'uint8');
B = zeros(0,'uint8');
M = uint8([0   0   0   0   0   0   0]);
Nmax = 270270;
Mflag = false;
Bflag = uint8(0);
dispflag = uint8(2);

% start timer
tic

% original
output1 = PMA_EnumerateAlg10(cVf,Vf,iInitRep,counts,phi,Ln,A,B,M,...
    Nmax,Mflag,Bflag,dispflag);
if displevel, toc, end

% mex version
try
    % run mex version
    tic
    output2 = PMA_EnumerateAlg10_mex(cVf,Vf,iInitRep,counts,phi,Ln,A,B,M,...
        Nmax,Mflag,Bflag,dispflag);
    if displevel, toc, end
    
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