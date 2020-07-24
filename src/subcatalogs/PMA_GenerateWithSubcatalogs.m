%--------------------------------------------------------------------------
% PMA_GenerateWithSubcatalogs.m
% Generate the set of unique, feasible graphs using subcatalogs of the
% original (L,P,R)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = PMA_GenerateWithSubcatalogs(L,Rs,Ps,NSC,opts)

% ensure that column vectors
Ps = Ps(:); Rs = Rs(:);

% if there are mandatory components but no R.min
if NSC.flag.Mflag && ~isfield(Rs,'min')

    % original R is the maximum number of replicates
    r.max = Rs;

    % initialize with zeros
    r.min = zeros(size(Rs));

    % find the mandatory components
    I = find(NSC.M);

    % minimum # of replicates equals maximum # for mandatory components
    r.min(I) = r.max(I);

    % copy temporary variable
    Rs = r;
end

% extract
Rmin = Rs.min; Rmax = Rs.max;
Pmin = Ps.min; Pmax = Ps.max;
nscNrmin = NSC.Nr(1); nscNrmax = NSC.Nr(2);
nscNpmin = NSC.Np(1); nscNpmax = NSC.Np(2);
PENmatrix = NSC.PenaltyMatrix; PENvalue = NSC.PenaltyValue;
SATmatrix = NSC.SatisfactionMatrix; SATvalue = NSC.SatisfactionValue;

% enumerate subcatalogs
[Ls,Rs,Ps] = PMA_SubcatalogEnumerationAlg_v2(Rmin,Rmax,Pmin,Pmax,...
    nscNrmin,nscNrmax,nscNpmin,nscNpmax,PENmatrix,PENvalue,SATmatrix,...
    SATvalue,opts.displevel);

%----------------------------------------------------------------------
% subcatalog filters
%----------------------------------------------------------------------
% find and remove odd port subcatalogs
Npsubcatalogs = sum(Rs.*Ps,2);
passed = mod(Npsubcatalogs,2) == 0;
Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);

% find and remove zero port subcatalogs
% Npsubcatalogs = sum(Rs.*Ps,2);
% passed = Npsubcatalogs ~= 0;
% Ls = Ls(passed,:); Rs = Rs(passed,:); Ps = Ps(passed,:);

% (connected, simple, no loops) graph subcatalog filter
if NSC.flag.Cflag && all(NSC.simple) && ~NSC.flag.Lflag
    [Ls,Ps,Rs] = PMA_TreeFilter(Ls,Ps,Rs);
end

% (simple, no loops) graph subcatalog filter
if all(NSC.simple) && ~NSC.flag.Lflag
    [Ls,Ps,Rs] = PMA_SimpleGraphFilter(Ls,Ps,Rs);
end

% custom user-defined catalog-only NSC check
if ~isempty(NSC.userCatalogNSC)
    [Ls,Rs,Ps] = NSC.userCatalogNSC(L,Ls,Rs,Ps,NSC,opts);
end
%----------------------------------------------------------------------

% number of subcatalogs
Nsubcatalogs = size(Ls,1);

% output some stats to the command window
if (opts.displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Enumerating ',num2str(Nsubcatalogs),' subcatalogs after ',num2str(ttime),' s'])
end

% local NSC variables
localdirectA = NSC.directA; localmultiedgeA = NSC.multiedgeA;
localloops = NSC.loops; localsimple = NSC.simple;
localM = NSC.M; locallineTriple = NSC.lineTriple;

localuserGraphNSC = NSC.userGraphNSC;
localCflag = NSC.flag.Cflag; localLflag = NSC.flag.Lflag;
localSflag = NSC.flag.Sflag; localMflag = NSC.flag.Mflag;
localBflag = NSC.flag.Bflag;

% change some of the options
displevel = opts.displevel; % save display flag
parallelflag = opts.parallel; % save parallel flag
opts.displevel = 0; % stop displaying so much stuff
opts.parallel = 0; % turn off parallel

% initialize
Graphs = cell(Nsubcatalogs,1);
Nfeasible = zeros(Nsubcatalogs,1);
idxFormat = ['%0',num2str(max(1,ceil(log10(Nsubcatalogs)))),'i']; % pad with correct number of zeros
strN = num2str(Nsubcatalogs);

% randomize the ordering of the catalogs
% DataPerm = randperm(Nsubcatalogs);
% Ls = Ls(DataPerm,:);
% Rs = Rs(DataPerm,:);
% Ps = Ps(DataPerm,:);

% sort the catalogs by total number of ports
[~,DataPerm] = sort(sum(Ps,2),'descend');
Ls = Ls(DataPerm,:);
Rs = Rs(DataPerm,:);
Ps = Ps(DataPerm,:);

% do each of the subcatalog tests
for k = 1:Nsubcatalogs

    % create temporary NSC structure to avoid parfor issues
    nsc = struct();
    nsc.directA = localdirectA;
    nsc.multiedgeA = localmultiedgeA;
    nsc.loops = localloops;
    nsc.simple = localsimple;
    nsc.M = localM;
    nsc.lineTriple = locallineTriple;
    nsc.userGraphNSC = localuserGraphNSC;
    nsc.flag.Cflag = localCflag;
    nsc.flag.Lflag = localLflag;
    nsc.flag.Sflag = localSflag;
    nsc.flag.Mflag = localMflag;
    nsc.flag.Bflag = localBflag;

    % extract (L,R,P) vector for this subcatalog test
    ln = Ls(k,:); r = Rs(k,:); p = Ps(k,:);

    % find nonzero types
    I = r~=0;

    % ensure row vectors
    ln = ln(:)'; r = r(:)'; p = p(:)';

    % extract numeric labels, replicates vector, and ports vector
    ln = ln(I);
    r = r(I);
    p = p(I);

    % extract labels
    l = L(ln); l = l(:)';

    % append port numbers to labels
    l = cellstr(strcat(l,string(p)));

    % extract reduced potential adjacency matrix
    nsc.directA = localdirectA(ln,ln);

    % extract multiedge adjacency matrix
    nsc.multiedgeA = localmultiedgeA(ln,ln);

    % extract nsc vectors
    nsc.loops = localloops(ln);
    nsc.simple = localsimple(ln);
    nsc.M = localM(ln);

    % set all types as mandatory is connected graph is required
    if localCflag
       nsc.M = true(size(nsc.M));
    end

    % extract appropriate line-connectivity triples
    if localBflag
        nsc.lineTriple = PMA_ExtractLineConstraints(nsc.lineTriple,ln);
    end

    % update flags
    nsc.flag.Cflag = localCflag;
    nsc.flag.Lflag = logical(any(nsc.loops));
    nsc.flag.Sflag = logical(any(nsc.simple));
    nsc.flag.Mflag = logical(any(nsc.M));
    nsc.flag.Bflag = logical(~isempty(nsc.lineTriple));

    % sort (L,R,P) to be better suited for enumeration
    [p,r,l,nsc,sorts] = PMA_ReorderCRP(p,r,l,nsc,opts);

    % check for parallel computing
    if parallelflag > 0
        % generate feasible graphs for this catalog
        F(k) = parfeval(@PMA_GenerateWithSubcatalog,2,l,r,p,nsc,opts,sorts);
    else
        % generate feasible graphs for this catalog
        [Graphs{k},Nfeasible(k)] = PMA_GenerateWithSubcatalog(l,r,p,nsc,opts,sorts);

        % local display function
        SubcatalogsDispFunc(displevel,k,idxFormat,strN,length(Graphs{k}),Nfeasible(k));
    end

end

% check for parallel computing
if parallelflag > 0
    % fetchNext blocks until next results are available
    for k = 1:Nsubcatalogs
        % fetchNext blocks until next results are available.
        [completedIdx,O1,O2] = fetchNext(F);

        % store results
        Graphs{completedIdx} = O1;
        Nfeasible(completedIdx) = O2;

        % local display function
        SubcatalogsDispFunc(displevel,k,idxFormat,strN,length(O1),O2);
    end
end

% remove subcatalogs with no feasible graphs
Graphs(cellfun('isempty',Graphs)) = [];

% reset opts
opts.displevel = displevel;
opts.parallel = parallelflag;

% combine all unique, feasible graphs
FinalGraphs = horzcat(Graphs{:});

% number of unique, feasible graphs
Nunique = length(FinalGraphs);

% return empty structure with no feasible graphs
if Nunique == 0
    FinalGraphs = [];
end

% output some stats to the command window
if (displevel > 0) % minimal
    ttime = toc; % stop the timer
    disp(['Found ',num2str(Nunique),' unique, feasible graphs in ',num2str(ttime),' s'])
    disp([' -> graph generation using ',opts.algorithm])
    disp([' -> isomorphism checking using ',opts.isomethod])
end
end
% find unique, feasible graphs for a single subcatalog
function [Graphs,Nfeasible] = PMA_GenerateWithSubcatalog(l,r,p,nsc,opts,sorts)

% generate feasible graphs for this catalog
Graphs = PMA_GenerateFeasibleGraphs(l,r,p,nsc,opts,sorts);

% number of feasible graphs found
Nfeasible = length(Graphs);

% return if no feasible graphs
if Nfeasible == 0
    return
end

% update Ln (base 10) from L (base 36)
Graphs = PMA_UpdateLn(Graphs);

% remove labeled graph isomorphisms for this subcatalog
Graphs = PMA_RemoveIsoLabeledGraphs(Graphs,opts);

end
% local display functions
function SubcatalogsDispFunc(displevel,idx,idxFormat,strN,Nunique,Nfeasible)

% display some diagnostics
if (displevel > 1) % verbose

    % stop the timer
    ttime = toc;

    % print
    disp(['I: ', num2str(idx, idxFormat),'/',strN,...
        ' | T: ',num2str(ttime, '%10.3e'),'s',...
        ' | Unique/Feasible Graphs: ',num2str(Nunique),'/',num2str(Nfeasible)]);
end
end