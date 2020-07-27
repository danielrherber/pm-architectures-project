%--------------------------------------------------------------------------
% PMA_ReorderCRP.m
% Sort (C,R,P) to be better suited for enumeration
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [P,R,C,NSC,Sorts] = PMA_ReorderCRP(P,R,C,NSC,opts)

% ensure column vectors
P = P(:);
R = R(:);

% determine the sorting indices
if opts.sortflag
    switch opts.algorithm
        %--------------------------------------------------------------
        case 'tree_v5' % sort P largest to smallest
        [~,I] = sortrows([P,R],'descend');
        %--------------------------------------------------------------
        otherwise % sort P smallest to largest
        [~,I] = sortrows([P,R],'ascend');
        %--------------------------------------------------------------
    end
else
    % default ordering (i.e., no sorting)
    I = (1:length(R))';
end

% save sort order for future unsorting of the adjacency matrix
SortCell = cell(1,length(R));
idx = 0;
for k = 1:length(R)
    SortCell{k} = idx+1:idx+R(k);
    idx = max(SortCell{k});
end
SortArray = cell2mat(SortCell(I));
[~,ISorts] = sort(SortArray);

% original ordering
Sorts.P = P;
Sorts.R = R;
Sorts.C = C;
Sorts.NSC = NSC;
Sorts.I = ISorts;

% order the other items
P = P(I);
R = R(I);
C = C(I);
NSC.M = NSC.M(I);
NSC.simple = NSC.simple(I);
NSC.loops = NSC.loops(I);
NSC.directA = NSC.directA(I,:);
NSC.directA = NSC.directA(:,I);
NSC.multiedgeA = NSC.multiedgeA(I,:);
NSC.multiedgeA = NSC.multiedgeA(:,I);
NSC.lineTriple = PMA_changem(NSC.lineTriple,1:length(P),I);

end
% notes on the formula
% sortrows([P,R],'ascend')
% weight number of ports the highest
% but also sort by replicate number