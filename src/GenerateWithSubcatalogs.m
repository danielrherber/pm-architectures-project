%--------------------------------------------------------------------------
% GenerateWithSubcatalogs.m
%
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function FinalGraphs = GenerateWithSubcatalogs(C,R,P,NSC,opts)

    % if there are mandatory components but no R.min
    if NSC.flag.Nflag && ~isfield(R,'min')
        % original R is the maximum number of replicates
        r.max = R;
        
        % initialize with zeros
        r.min = zeros(size(R));
        
        % find the mandatory components
        I = find(NSC.M);
        
        % minimum # of replicates equals maximum # for mandatory components
        r.min(I) = r.max(I);
        
        R = r;
    end
    
    % number of subcatalogs
    Nsubcatalogs = prod(R.max-R.min+1);

    Rlist = cell(numel(R.max),1); % initialize
    for k = 1:numel(R.max) % for each component type
        Rlist{k} = R.min(k):R.max(k); % list of potential number of replicates
    end
    
    %  generate all subcatalogs
    Subcatalogs = cell(1,numel(Rlist)); % initialize
    [Subcatalogs{:}] = ndgrid(Rlist{:});

    % local NSC variables 
    localA = NSC.A; localBind = NSC.Bind;
    localcounts = NSC.counts;
    localCflag = NSC.flag.Cflag; localNflag = NSC.flag.Nflag;
    localBflag = NSC.flag.Bflag;
    
    % change some of the options
    displevel = opts.displevel; % save display flag
    parallelflag = opts.parallel; % save parallel flag
    opts.displevel = 0; % stop displaying so much stuff
    opts.parallel = 0; % turn off parallel

    % initialize
    Graphs = cell(Nsubcatalogs,1);
    G = zeros(Nsubcatalogs,1);

    % do each of the catalog tests (potentially in parallel)
    parfor (k = 1:Nsubcatalogs, parallelflag)
%     for k = 1:Nsubcatalogs
        
        % create temporary NSC structure to avoid parfor issues
        nsc = struct();
        nsc.A = localA;
        nsc.Bind = localBind;
        nsc.counts = localcounts;
        nsc.flag.Cflag = localCflag;
        nsc.flag.Nflag = localNflag;
        nsc.flag.Bflag = localBflag;
        
        % extract R vector for this catalog test
        r = zeros(numel(R.max),1);
        for i = 1:numel(R.max)
            r(i) = Subcatalogs{i}(k);
        end

        % calculate number of ports
        Np = dot(P,r);

        % only do the catalog test if the Np is even (or nonzero)
        if ~mod(Np,2) && (Np~=0) % if even
            
            % find nonzero component types
            I = r~=0;
            
            % ensure that it is a row vector
            r = r(:)';
            
            % extract colored labels, replicates vector, and ports vector
            c = C(I);
            r = r(I);
            p = P(I);
            
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
            nsc.M = ones(size(I));
            
            % sort {C, R, P} to be better suited for enumeration
            [p,r,c,nsc] = ReorderCRP(p,r,c,nsc,opts);
            
            % generate feasible graphs for this catalog
            Graphs{k} = GenerateFeasibleGraphs(c,r,p,nsc,opts);
            
            % store the number of feasible graphs found
            G(k) = length(Graphs{k});
            
            % display some diagnostics
            if (displevel > 1) % verbose
                disp(['Found ',num2str(G(k)),' feasible graphs with R = ',mat2str(r),'  ',num2str(k)]);
            end

        end
    end
    
    % output some stats to the command window
    if (displevel > 0) % minimal
        ttime = toc; % stop the timer
        disp(['Found ',num2str(sum(G)),' feasible graphs in ',num2str(ttime),' s'])
    end    
    
    % initialize
    g = zeros(Nsubcatalogs,1);
    
    % check for colored graph isomorphisms
    if strcmpi(opts.isomethod,'python')
        for k = 1:Nsubcatalogs
            Graphs{k} = RemovedColoredIsos(Graphs{k},opts);
            % store the number of unique graphs found
            g(k) = length(Graphs{k});
        end
    elseif strcmpi(opts.isomethod,'matlab')
        parfor (k = 1:Nsubcatalogs, parallelflag)
            Graphs{k} = RemovedColoredIsos(Graphs{k},opts);
            % store the number of unique graphs found
            g(k) = length(Graphs{k});
        end
    end

    % reset opts
    opts.displevel = displevel;
    opts.parallel = parallelflag;

    % initialize output
    ind = 0; 
    
    % append unique, feasible graphs
    for k = 1:Nsubcatalogs % loop through each of catalog tests
        % loop through each unique graph in 
        for i = 1:length(Graphs{k})
            ind = ind + 1;
            FinalGraphs(ind) = Graphs{k}(i);
        end
    end
    
    % output some stats to the command window
    if (opts.displevel > 0) % minimal
        ttime = toc; % stop the timer
        disp(['Found ',num2str(sum(g)),' unique graphs in ',num2str(ttime),' s'])
    end

end