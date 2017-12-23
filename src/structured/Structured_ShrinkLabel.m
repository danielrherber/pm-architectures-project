%--------------------------------------------------------------------------
% Structured_ShrinkLabel.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Additional Contributor: Shangtingli,Undergraduate Student,University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [P,B,C]= Structured_ShrinkLabel(Graph)
    %Get the label information
    LStructured_ = Graph.L;
    
    %Modify the Graph.A to accomodate self loops (Maybe not needed)
    A = Graph.A;
    A = A+diag(diag(A));
    
    %Classify the simple components and structured components
    lengths = cellfun(@length,LStructured_);
    simple = LStructured_(find(lengths==1));
    structured = LStructured_(find(lengths >1));
    
    %===========Task: Dealing with Simple Components============
    Psimp = zeros(1,length(simple));
    Bsimp = zeros(1,length(simple));
    Csimp = cell(1,length(simple));
    
    %Simply record the label, and get the port number according adjacency
    %matrix
    for i = 1:length(simple)
        Csimp{i} = simple{i};
        Psimp(i) = sum(A(i,:));
    end    
    
    %===========Task: Dealing with Structured_ Components============
    
    %Initialize C, P array for structured components only
    Cstr = {};
    Pstr = [];
    %prev Port Number for comparison
    prevPN = 0;    
    %Index iterating through the array of structued Component
    idx = 1;
    
    %Index which we use to actually write into Cstr and Pstr
    writeIdx = 1;
    
    %Get the letter and port number of the current component
    letter = structured{idx}(1);
    PN = str2num(structured{idx}(2:end));
    
    
    while idx <= length(structured)
        %Record the letter in Cstr and initialize an entry in Pstr
        Cstr{writeIdx} = letter;
        Pstr = [Pstr 0];
        
        %While the port number is greater (Which means they
        %are still the same component) We simply update the existing Pstr
        %entry.
        while PN > prevPN
            Pstr(writeIdx) = Pstr(writeIdx)+1;
            prevPN = PN;
            idx = idx+1;
            if idx <= length(structured)
                letter = structured{idx}(1);
                PN = str2num(structured{idx}(2:end));
            end
        end
        
        %Update prevnodeNum, writeIdx for another iteration
        prevPN = 0;
        writeIdx = writeIdx +1;
    end
    
    %Update B array for structured components
    Bstr = ones(1,length(Pstr));
    
    %Combine P,B,C for both simple and structured components
    %Assumption taken: Simple components always go first
    P = [Psimp Pstr];
    B = [Bsimp Bstr];
    C = [Csimp,Cstr];
end