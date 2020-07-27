%--------------------------------------------------------------------------
% PMA_STRUCT_HelpAdjacencyNSC.m
% Helper function for structured labels
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function ConstraintMatrix = PMA_STRUCT_HelpAdjacencyNSC(C,P,S)

% specify the final expansion of labeled matrix
AdjType = PMA_STRUCT_DispAdjacencyIdxLabels(C,P,S);
% AdjType = 1 is simple reduced
% AdjType = 2 is structured reduced

% get input from users
choices = prompt_user(P,S,AdjType);

% get the size of the actual labeled location
size_elem = getNumberOfElements(P,S,AdjType);

% set up the matrix to represent constraints (initially all 1)
ConstraintMatrix = ones(size_elem);

% index tools to go through 'choices' array iteratively
index = 1;

% get input from the 'choices' array and update 'ConstraintMatrix'
while choices(index) ~= 0
    num1 = choices(index);
    num2 = choices(index + 1);
    ConstraintMatrix(num1,num2) = 0;
    ConstraintMatrix(num2,num1) = 0;
    index = index + 2;
end

end
%--------------------------------------------------------------------------
% Give prompts for users to input the constraint location accordingly
function array = prompt_user(P,S,AdjType)

% set two numbers as a pair to locate one constraint
% Ex. [1,2,3,4] represents (1,2) = 0, (3,4) = 0 (up  to 50 constraints)
array = zeros(1,100);

% prompt the user to choose to add a constraint or not
prompt = 'Do you want to add a constraint? Enter Y, or N to quit: ';

% get the user choice
choice = upper(input(prompt,'s')); % force uppercase
while ~strcmp(choice,'Y') && ~strcmp(choice,'N')
    disp('Not a valid Choice: ');
    prompt = 'Do you want to add a constraint? Enter Y, or N to quit: ';
    choice = upper(input(prompt,'s'));
end

% set up initial constraint number
Cons_num = 1;

% count for the numbers of indexes used for constraints
count = 1;

% this is used to disable invalid entry of index
size_elem = getNumberOfElements(P,S,AdjType);

while strcmp(choice,'Y')
% prompt the user to enter the first number used for that specific constraint
string1 = ['Constraint ', num2str(Cons_num), ', row: '];
prompt1 = string1;
choice1 = input(prompt1);

% if the number entered is invalid, we keep asking for a number until it is valid
while (choice1 > size_elem) || (choice1 < 1)
    disp('The index you entered earlier is invalid: ');
    prompt1 = string1;
    choice1 = input(prompt1);
end

% store the input in the array and update the count number
array(count) = choice1;
count = count + 1;

% prompt the user to enter the second number used for that specific
% constraint, same protocol as the first number
string2 = ['Constraint ', num2str(Cons_num), ', column: '];
prompt2 = string2;
choice2 = input(prompt2);
while (choice2 > size_elem) || (choice2 < 1)
    disp('The index you entered earlier is invalid: ');
    prompt2 = string2;
    choice2 = input(prompt2);
end
array(count) = choice2;
count = count + 1;

% after we have two numbers, we have successfully set up a constraint,
% and we update the constraint number used for string concatenation
Cons_num = Cons_num+1;

% ask user if another constraint is needed
prompt = 'Do you want to continue adding a constraint? Enter Y, or N to quit: ';
choice = upper(input(prompt,'s'));
    while ~strcmp(choice,'Y') && ~strcmp(choice,'N')
        disp('Not a valid choice: ');
        prompt = 'Do you want to continue adding a constraint? Enter Y, or N to quit: ';
        choice = upper(input(prompt,'s'));
    end
end
end
%--------------------------------------------------------------------------
% simple function to find the actual number of labels we need to
% consider after expansion
function size_elem = getNumberOfElements(P,S,AdjType)

% calculate total # of entries
if strcmp(AdjType,'1')
    size_elem = length(S);
elseif strcmp(AdjType,'2')
    size_elem = sum(S.*P) + sum(~S); % structured + simple
end

end
%--------------------------------------------------------------------------