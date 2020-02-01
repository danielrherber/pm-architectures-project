%--------------------------------------------------------------------------
% PMA_PadCatRowVectors.m
% Concatenate vectors with different lengths by padding with 0
% Code modified from MFX 22909
%--------------------------------------------------------------------------
% Based on https://www.mathworks.com/matlabcentral/fileexchange/22909
% Modified for only row vector inputs (much faster)
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Y = PMA_PadCatRowVectors(varargin)

% check number of input arguments
if nargin == 1
    % single input so nothing to concatenate
    Y = varargin{1};

else
    % lengths of each input row vector
    lengthM = cellfun('length',varargin);

    % length of the longest vector
    maxX = max(lengthM);

    % make a single large list
    X = cat(2, varargin{:});

    % use linear indexing, which operates along columns
    if maxX == 1 % all inputs are scalars
        % copy the list
        Y = X;

    elseif min(lengthM) == max(lengthM) % all vectors have the same length
        % copy the list and reshape
        Y = reshape(X,maxX,[]);

    else
        % preallocate the final output array as a column oriented array
        % make it one larger to accommodate the largest vector
        Y = zeros([maxX+1 nargin],class(X));

        % determine the location of the first filler in each column
        Y(sub2ind(size(Y),lengthM+1,1:nargin)) = 1;

        % apply cumsum on the columns because filler values should be put
        % after initial position (also remove last row)
        Y = cumsum(Y(1:end-1,:),1);

        % location of original data
        I = (Y==0);

        % original data
        Y(I) = X;

        % filler values
        Y(~I) = 0;

    end

    % inputs were row vectors, so transpose
    Y = Y.';

end