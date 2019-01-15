%--------------------------------------------------------------------------
% PMA_GenerateWithSubcatalogs.m
% Generate the set of unique, feasible graphs using subcatalogs of the
% original (C,R,P)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = PMA_GenerateWithSubcatalogs(C,R,P,NSC,opts)

    % ensure that column vectors 
    P = P(:); R = R(:);
    
    % if there are mandatory components but no R.min
    if NSC.flag.Mflag && ~isfield(R,'min')
        % original R is the maximum number of replicates
        r.max = R;
        
        % initialize with zeros
        r.min = zeros(size(R));
        
        % find the mandatory components
        I = find(NSC.M);
        
        % minimum # of replicates equals maximum # for mandatory components
        r.min(I) = r.max(I);
        
        % copy temporary variable
        R = r;
    end
    
    % create list of replicates
    Rlist = cell(numel(R.max),1); % initialize
    for k = 1:numel(R.max) % for each component type
        Rlist{k} = R.min(k):R.max(k); % list of potential number of replicates
    end
    
    %  generate all subcatalogs
    SubcatalogsCell = cell(1,numel(Rlist)); % initialize
    [SubcatalogsCell{:}] = ndgrid(Rlist{:});

    % create array from cell structure
    for k = 1:numel(R.max) % for each component type
        Subcatalogs(:,k) = SubcatalogsCell{k}(:);
    end
    
    % find and remove odd port subcatalogs
    Subcatalogs( (mod(Subcatalogs*P,2) == 1), :) = [];
    
    % find and remove zero port subcatalogs
    Subcatalogs( (Subcatalogs*P == 0), :) = [];
    
    % custom subcatalog filter function
    if isfield(opts,'subcatalogfun')
        Subcatalogs = opts.subcatalogfun(Subcatalogs,C,R,P,NSC,opts);
    end
    
    % number of subcatalogs
    Nsubcatalogs = size(Subcatalogs,1);

    % local NSC variables 
    localA = NSC.A; localBind = NSC.Bind;
    localcounts = NSC.counts;
    localCflag = NSC.flag.Cflag; localMflag = NSC.flag.Mflag;
    localBflag = NSC.flag.Bflag;
    
    % change some of the options
    displevel = opts.displevel; % save display flag
    parallelflag = opts.parallel; % save parallel flag
    opts.displevel = 0; % stop displaying so much stuff
    opts.parallel = 0; % turn off parallel

    % initialize
    Graphs = cell(Nsubcatalogs,1);
    G = zeros(Nsubcatalogs,1);

    % randomize the ordering of the catalogs
    DataPerm = randperm(Nsubcatalogs);
    Subcatalogs = Subcatalogs(DataPerm,:);
    
    % do each of the subcatalog tests
    for k = 1:Nsubcatalogs

        % create temporary NSC structure to avoid parfor issues
        nsc = struct();
        nsc.A = localA;
        nsc.Bind = localBind;
        nsc.counts = localcounts;
        nsc.flag.Cflag = localCflag;
        nsc.flag.Mflag = localMflag;
        nsc.flag.Bflag = localBflag;

        % extract R vector for this subcatalog test
        r = Subcatalogs(k,:);

        % find nonzero component types
        I = r~=0;

        % ensure that it is a row vector
        r = r(:)';

        % extract colored labels, replicates vector, and ports vector
        c = C(I);
        r = r(I);
        p = P(I);

        % extract counts vector
        nsc.counts = localcounts(I);

        % extract reduced potential adjacency matrix
        nsc.A = localA(I,:);
        nsc.A = nsc.A(:,I);

        % extract appropriate line-connectivity triples
        org = find(I);
        new = 1:numel(org);
        for t = size(nsc.Bind,1):-1:1
            if ~all(ismember(nsc.Bind(t,:),find(I)))
                nsc.Bind(t,:) = []; % remove the constraint
            else
                nsc.Bind(t,:) = changem(nsc.Bind(t,:),new,org);
            end
        end

        % all component types are mandatory
        nsc.M = ones(size(new));
        
        % update flags
        nsc.flag.Cflag = uint8(any(nsc.counts));
        nsc.flag.Mflag = true;
        nsc.flag.Bflag = uint8(~isempty(nsc.Bind));

        % sort {C, R, P} to be better suited for enumeration
        [p,r,c,nsc,sorts] = ReorderCRP(p,r,c,nsc,opts);

        % check for parallel computing
        if parallelflag > 0
            % generate feasible graphs for this catalog
            F(k) = parfeval(@PMA_GenerateFeasibleGraphs,1,c,r,p,nsc,opts,sorts);
        else
            % generate feasible graphs for this catalog
            Graphs{k} = PMA_GenerateFeasibleGraphs(c,r,p,nsc,opts,sorts);
            
            % local display function
            G = SubcatalogsDispFunc(k,G,Graphs,Subcatalogs,displevel);
        end

    end

    % check for parallel computing
    if parallelflag > 0
        % fetchNext blocks until next results are available
        for k = 1:Nsubcatalogs
            % fetchNext blocks until next results are available.
            [completedIdx,value] = fetchNext(F);
            
            % store results
            Graphs{completedIdx} = value;
            
            % local display function
            G = SubcatalogsDispFunc(completedIdx,G,Graphs,Subcatalogs,displevel);

        end
    end

    % output some stats to the command window
    if (displevel > 0) % minimal
        ttime = toc; % stop the timer
        disp(['Found ',num2str(sum(G)),' feasible graphs in ',num2str(ttime),' s'])
    end    
        
    % remove subcatalogs with no feasible graphs
    Graphs(cellfun('isempty',Graphs)) = [];
    
    %----------------------------------------------------------------------
    % START TASK: remove colored graph isomorphisms
    %----------------------------------------------------------------------
    % number of subcatalogs with at least one feasible graph
    Nfeasible = length(Graphs);
    
    % initialize
    graphs = cell(Nfeasible,1);
    g = zeros(Nfeasible,1);

    % check for colored graph isomorphisms
    for k = 1:Nfeasible
        if parallelflag > 0 % check for parallel computing
            % remove colored graph isomorphisms for this subcatalog
            f(k) = parfeval(@PMA_RemoveIsoColoredGraphs,1,Graphs{k},opts);
        else
            % remove colored graph isomorphisms for this subcatalog
            graphs{k} = PMA_RemoveIsoColoredGraphs(Graphs{k},opts);
            
            % local display function
            g = IsoDispFunc(k,g,length(graphs{k}),length(Graphs{k}),...
                displevel,Nfeasible,opts.isomethod);
      
        end
    end

    if parallelflag > 0 % check for parallel computing
        % fetchNext blocks until next results are available
        for k = 1:Nfeasible
            % fetchNext blocks until next results are available.
            [completedIdx,value] = fetchNext(f);
            
            % store results
            graphs{completedIdx} = value;

            % local display function
            g = IsoDispFunc(completedIdx,g,length(value),length(Graphs{completedIdx}),...
                displevel,Nfeasible,opts.isomethod);

        end
    end

    %----------------------------------------------------------------------
    % END TASK: remove colored graph isomorphisms
    %----------------------------------------------------------------------

    % reset opts
    opts.displevel = displevel;
    opts.parallel = parallelflag;

    % initialize output
    ind = 0; 
    
    % append unique, feasible graphs
    for k = 1:Nfeasible % loop through each of catalog tests
        % loop through each unique graph in 
        for i = 1:length(graphs{k})
            ind = ind + 1;
            FinalGraphs(ind) = graphs{k}(i);
        end
    end
    
    % return empty structure with no feasible graphs
    if Nfeasible == 0
        FinalGraphs = [];
    end
    
    % output some stats to the command window
    if (opts.displevel > 0) % minimal
        if strcmpi(opts.isomethod,'none')
            disp('-> no isomorphism checking using the ''none'' option')
        else
            ttime = toc; % stop the timer
            disp(['Found ',num2str(sum(g)),' unique graphs in ',num2str(ttime),' s'])
        end
    end

end
% local display functions
function G = SubcatalogsDispFunc(idx,G,Graphs,Subcatalogs,displevel)

    % store the number of feasible graphs found
    G(idx) = length(Graphs{idx});

    % display some diagnostics
    if (displevel > 1) % verbose
        % stop the timer
        ttime = toc; 

        % number of subcatalogs
        NSubcatalogs = size(Subcatalogs,1);

        % pad with correct number of zeros
        idxFormat = ['%0',num2str(max(1,ceil(log10(NSubcatalogs)))),'i'];

        % print
        disp(['I: ', num2str(idx, idxFormat),'/',num2str(NSubcatalogs),...
            ' | T: ',num2str(ttime, '%10.3e'),'s',...
            ' | R: ',mat2str(Subcatalogs(idx,:)),...
            ' | Graphs (feasible): ', num2str(G(idx)),]);
    end

end
function g = IsoDispFunc(idx,g,Ngraphs,NGraphs,displevel,Nfeasible,isomethod)

    % store the number of unique graphs found
    g(idx) = Ngraphs;

    % display some diagnostics
    if (displevel > 1) && ~strcmpi(isomethod,'none') % verbose
        % stop the timer
        ttime = toc;

        % pad with correct number of zeros
        idxFormat = ['%0',num2str(max(1,ceil(log10(Nfeasible)))),'i'];

        % print
        disp(['I: ', num2str(idx, idxFormat),'/',num2str(Nfeasible),...
            ' | T: ',num2str(ttime, '%10.3e'),'s',...
            ' | Graphs (unique/total): ',num2str(Ngraphs),'/',num2str(NGraphs)]);
    end

end