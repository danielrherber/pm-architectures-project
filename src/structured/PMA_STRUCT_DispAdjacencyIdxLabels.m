%--------------------------------------------------------------------------
% PMA_STRUCT_DispAdjacencyIdxLabels.m
% Helps display final label list and construct directA
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function AdjType = PMA_STRUCT_DispAdjacencyIdxLabels(L,P,S)

% prompt the user to say simple reduced or structured reduced
prompt = 'Do you want simple reduced (1) or structure reduced (2): ';

% get the user choice
choice = upper(input(prompt,'s')); % force uppercase
while ~strcmp(choice,'1') && ~strcmp(choice,'2')
    choice = upper(input('Not a valid Choice: ','s')); % force uppercase
end

%--------------------------------------------------------------------------
% do the selected option

% option: simple reduced
if strcmp(choice,'1')

    % calculate total # of entries
    real_num = length(L);

    % display numbers and labels
    for k = 1:real_num
        disp([num2str(k),' - ',L{k}])
    end

% option: structured reduced
elseif strcmp(choice,'2')

    % set simple component's # of ports to 1
    P(~S) = 1;

    % save original P
    Porg = P;

    % calculate total # of entries
    real_num = sum(S.*P) + sum(~S); % structured + simple

    % display numbers and labels
    for k = 1:real_num

        % find first nonzero value
        I = find(P,1,'first');

        % remove the port
        P(I) = P(I) - 1;

        % if simple
        if S(I) == 0
            disp([num2str(k),' - ',L{I}]) % don't display a number
        % if structured
        elseif S(I) == 1
            disp([num2str(k),' - ',L{I},num2str(Porg(I)-P(I))])
        end

    end

end

AdjType = choice;

end