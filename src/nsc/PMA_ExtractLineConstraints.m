%--------------------------------------------------------------------------
% PMA_ExtractLineConstraints.m
% Extract appropriate line-connectivity triples
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function lineTriple = PMA_ExtractLineConstraints(lineTriple,org)

% new index locations
new = 1:numel(org);

% check for what component types are still present
Bln = false(size(lineTriple));
for t = 1:length(org)
    Bln = Bln | lineTriple==org(t);
end

% keep relevant constraints only
lineTriple = lineTriple(all(Bln,2),:);

% initialize temporary lineTriple where replacements will be made
Btemp = zeros(size(lineTriple));

% go through each component type in lineTriple
for t = unique(lineTriple(:)')

    % new replacement indices
    Inew = new(org==t);

    % simple 1 to 1 replacement
    if numel(Inew) == 1
        Btemp(lineTriple==t) = Inew;
        continue
    end

    % locations that need to be updated
    Irow = lineTriple==t;

    % calculate the row replacements
    Nreplace = sum(Irow,2);

    % initialize
    Bout = cell(size(Btemp,1));
    Bind2 = Bout;

    % go through each row in lineTriple
    for w = 1:size(Btemp,1)

        % extract current row
        b3 = Btemp(w,:);

        % number of replacements in this row
        nreplace = Nreplace(w);

        % optimized grid for the four potential cases
        if nreplace == 0
            Bout{w} = b3;
            continue
        elseif nreplace == 1
            C1 = Inew;
        elseif nreplace == 2
            C1 = repmat(Inew,size(Inew));
            C2 = C1';
        elseif nreplace == 3
            [C1,C2,C3] = meshgrid(Inew,Inew,Inew);
        else
            error('matrix wrong size?')
        end

        % total number permutations
        nperm = numel(C1);

        % find the locations of the replacements
        irow = find(Irow(w,:));

        % go through and replace each element
        for idxr = 1:nreplace
            % extract current column replacement index
            ireplace = irow(idxr);

            if idxr == 1
                % expand and add
                b3 = [repelem(b3(:,1:ireplace-1),nperm,1), C1(:),...
                    repelem(b3(:,ireplace+1:end),nperm,1)];
            elseif idxr == 2
                % add column
                b3(:,ireplace) = C2(:);
            elseif idxr == 3
                % add column
                b3(:,ireplace) = C3(:);
            end
        end

        % add
        Bout{w} = b3;
        Bind2{w} = repmat(lineTriple(w,:),nperm,1);
    end

    % combine
    Btemp = vertcat(Bout{:});
    lineTriple = vertcat(Bind2{:});
end

% output updated line-connectivity constraints
lineTriple = Btemp;