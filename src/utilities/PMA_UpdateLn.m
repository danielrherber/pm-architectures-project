%--------------------------------------------------------------------------
% PMA_UpdateLn.m
% Update Ln (base 10) from L (base 36)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Graphs = PMA_UpdateLn(Graphs)

% current decimal labels
Ln = vertcat(Graphs.Ln);

% check if we need to update the decimal labels
if any(isnan(Ln))

    % extract labels
    L = {Graphs.L};

    % convert base 36 string to decimal integer
    Ln = fbase2dec(char(vertcat(L{:})),36)';

    % split up into properly sized cells
    Ln = mat2cell(Ln,1,cellfun(@numel,L));

    % assign decimal labels
    [Graphs.Ln] = deal(Ln{:});

end

end