%--------------------------------------------------------------------------
% PMA_STRUCT_UniqueUsefulGraphs.m
% Given a set of unique simple graphs with structured components specified,
% find the set of unique structured graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on GitHub
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Graphs = PMA_STRUCT_UniqueUsefulGraphs(C,R,P,NSC,opts,iGraphs)

% extract
displevel = opts.displevel;
parallelflag = opts.structured.parallel;

% structured components vector
S = NSC.S;

% number of input graphs
n = length(iGraphs);

% initialize
Graphs = cell(1,n);
idxFormat = ['%0',num2str(max(1,ceil(log10(n)))),'i']; % pad with correct number of zeros
strN = num2str(n);

% expand all input graphs with respect to the structured components
for k = 1:n

    % check for parallel computing
    if parallelflag > 0

        % generate all structured graphs for this simple graph
        F(k) = parfeval(@PMA_STRUCT_Sort,1,C,P,S,opts,iGraphs(k));

    else

        % generate all structured graphs for this simple graph
        Graphs{k} = PMA_STRUCT_Sort(C,P,S,opts,iGraphs(k));

        % local display function
        StructuredDispFunc(displevel,k,idxFormat,strN,length(Graphs{k}));

    end

end

% check for parallel computing
if parallelflag > 0

    % fetchNext blocks until next results are available
    for k = 1:n

        % fetchNext blocks until next results are available.
        [completedIdx,O1] = fetchNext(F);

        % store results
        Graphs{completedIdx} = O1;

        % local display function
        StructuredDispFunc(displevel,k,idxFormat,strN,length(O1));

    end
end

% combine
Graphs = horzcat(Graphs{:});

% output some stats to the command window
if (displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Found ',num2str(length(Graphs)),...
        ' unique structured graphs in ', num2str(ttime),' s'])
end

end

% local display function
function StructuredDispFunc(displevel,idx,idxFormat,strN,Nunique)

% display some diagnostics
if (displevel > 1) % verbose

    % stop the timer
    ttime = toc;

    % print
    disp(['I: ', num2str(idx, idxFormat),'/',strN,...
        ' | T: ',num2str(ttime, '%10.3e'),'s',...
        ' | Unique Structured Graphs: ',num2str(Nunique)]);
end

end