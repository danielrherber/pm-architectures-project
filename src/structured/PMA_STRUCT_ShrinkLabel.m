%--------------------------------------------------------------------------
% PMA_STRUCT_ShrinkLabel.m
% Obtain equivalent simple graph labels and ports from a structured graph
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%-------------------------------------------------------------------------
function [P,S,C]= PMA_STRUCT_ShrinkLabel(Graph)

% copy label information
LStructured = Graph.L;

% modify Graph.A to accommodate self loops (potentially unnecessary)
A = Graph.A;
A = A + diag(diag(A));

% classify the simple components and structured components
structuredIdx = cellfun(@(x) any(x), isstrprop(LStructured,'digit'));
simple = LStructured(~structuredIdx);
structured = LStructured(structuredIdx);

%----------------------------------------------------------------------
% Task: handling simple components
%----------------------------------------------------------------------
Psimp = zeros(1,length(simple));
Bsimp = zeros(1,length(simple));
Csimp = cell(1,length(simple));

% record the label and get the number of ports
for i = 1:length(simple)
    Csimp{i} = simple{i};
    Psimp(i) = sum(A(i,:));
end

%----------------------------------------------------------------------
% Task: handling structured components
%----------------------------------------------------------------------
% initialize (C,P) for structured components only
Cstr = {}; Pstr = [];

% initialize previous number of ports for comparison
prevPN = 0;

% initialize index iterating through the array of structured components
idx = 1;

% initialize index for actually writing into Cstr and Pstr
writeIdx = 1;

% get the letter and port number of the current component
letterIdx = isstrprop(structured{idx},'alpha');
letter = structured{idx}(letterIdx);
PN = str2double(structured{idx}(~letterIdx));

% while structured component labels remain
while idx <= length(structured)

    % record the letters in Cstr and initialize an entry in Pstr
    Cstr{writeIdx} = letter;
    Pstr = [Pstr,0];

    % while the port number is greater (implying that there are still
    % ports remaining), simple update the existing Pstr entry
    while PN > prevPN
        Pstr(writeIdx) = Pstr(writeIdx)+1;
        prevPN = PN;
        idx = idx+1;
        if idx <= length(structured)
            letter = structured{idx}(1);
            PN = str2num(structured{idx}(2:end));
        end
    end

    % update prevnodeNum, writeIdx for another iteration
    prevPN = 0;
    writeIdx = writeIdx + 1;

end

% update S array for structured components
Sstr = ones(1,length(Pstr));

%----------------------------------------------------------------------
% Task: combine (C,P,S) for both simple and structured components
%----------------------------------------------------------------------
% simple components always come first
P = [Psimp Pstr];
S = [Bsimp Sstr];
C = [Csimp,Cstr];

end