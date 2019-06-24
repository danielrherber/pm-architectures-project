%--------------------------------------------------------------------------
% PMA_IsoBFS.m
% Isomorphism checking function for breadth-first search algorithms
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Queue = PMA_IsoBFS(Queue,Tsort,Ln,Nc,iter,Vsort,dispflag,Ncheck,isomethod)

    % isomorphism checking method
    switch isomethod
        case 1 % matlab implementation
            Queue = MATLABiso(Queue,Tsort,Ln,Nc,iter);
        case 2 % python implementation
            Queue = PYTHONiso(Queue,Tsort,Ln,Nc,iter,Vsort,dispflag,Ncheck);
        otherwise
            error('Unknown isomorphism checking option selected')
    end

end
% python implementation
function Queue = PYTHONiso(Queue,Tin,Ln,Nc,iter,Vin,dispflag,Ncheck)

    % check if we should perform the full isomorphism checks
    if ~isempty(Queue) && (length(Queue) <= Ncheck)

        % import isomorphism checking function
        py.importlib.import_module('detectiso_func4'); % import module 

        % determine reduced length labels 
        [~,~,VIC] = unique(Ln);
        
        % bins for histcounts
        bins = 0:Nc+1; 
        
        % initialize
        N = length(Queue);
        A = zeros(Nc,Nc,N,'double');
        T = zeros(N,Nc,'double');
        C = zeros(N,Nc+1,'double');
        S = cell(N,1);
        
        % compute various metrics once
        for idx = 1:length(Queue)
            % adjacency matrix
            At = zeros(Nc,'double');
            At(Tin(idx,end-iter+1:end)) = 1;
            At = At + At';
            A(:,:,idx) = At;
            
            % triangle distribution (sorted by color groups)
            At = At - diag(diag(At)); % remove self-loops (maybe not needed?)
            Tt = diag(At^3);
            T(idx,:) = Tt; % sort by color later
            
            % connected components distribution (uncolored)
            Ct = PMA_ConnCompBins(At); % connected component labeling
            C(idx,:) = sort(histcounts(Ct,bins)); % sort bins
            
            % connected components distribution (colored)
            S = cell(1,max(Ct)); % initialize
            % go through each connected component
            for k = 1:max(Ct)
                % convert to base 36 and sort labels in the connected component
                s = sort(dec2base(VIC(Ct==k),36)); % up to 35 unique component labels
                % add to list
                S{k} = s;
            end
            % sort the connected components
            S{idx} = sort(S);

        end
        
        % sort the metrics by color groups
        V = PMA_ColorBasedSorting(Vin,Ln); % degree distribution
        T = PMA_ColorBasedSorting(T,Ln); % triangle distribution

        % first graph is unique
        Keep = 1;

        % go through each graph in the queue
        for q = 2:length(Queue)
            % get metric for the current graph
            Atest = A(:,:,q);
            Vtest = V(q,:);
            Ttest = T(q,:);
            Ctest = C(q,:);
            Stest = S{q};

            % initialize isoFlag
            IsoFlag = false;

            % check some matrix based metrics
            Clogical = all(Ctest==C,2);
            Vlogical = all(Vtest==V,2); % should be degree sequences matching with respect to colors
            Tlogical = all(Ttest==T,2); % distribution of the numbers of triangles with respect to colors
            
            % combine
            Xlogical = Clogical & Vlogical & Tlogical;
            
            % go through all potentially isomorphic graphs
            for idx = flip(Keep(Xlogical(Keep)),2)
              % go through additional simple checks
              if isequal(Stest,S{idx}) % connected components distribution (colored)
                % check for full isomorphism
                IsoFlag = py.detectiso_func4.detectiso(Atest,A(:,:,idx),Ln,Ln,Nc,Nc);
                if IsoFlag
                  break    
                end
              end
            end

            % save, graph is unique
            if ~IsoFlag 
                Keep(end+1) = q;
            end
        end

        % print
        if dispflag > 2 % very verbose
            fprintf('  Removed graphs (Full ISO): %8d\n',length(Queue)-length(Keep))
        end

        % update queue
        Queue = Queue(Keep);

    end

end
% matlab implementation
% NOTE: this function is not finished, see python implementation above
function Queue = MATLABiso(Queue,Tsort,Ln,Nc,iter)
    % first graph is unique
    if length(Queue) < 10000000
    
    if ~isempty(Queue)
        Keep = 1;
        Anew  = zeros(Nc);
        Anew(Tsort(1,end-iter+1:end)) = 1;
        Gnew = graph(Anew,'lower');
        Gnew.Nodes.Color = Ln';
        KeepGraphs(1).G = Gnew;
    end

    for i = 2:length(Queue)

        Anew  = zeros(Nc);
        Anew(Tsort(i,end-iter+1:end)) = 1;
        Gnew = graph(Anew,'lower');
        Gnew.Nodes.Color = Ln';

        j = length(Keep); % number of graphs in the current bin
        IsoFlag = 0; % initialize isoFlag

        while (j > 0) && (IsoFlag == 0)

            idx = Keep(j);
            Gold = KeepGraphs(idx).G;

            if isisomorphic(Gnew,Gold,'NodeVariables','Color')
                IsoFlag = 1;
            end
            j = j - 1;
        end

        if ~IsoFlag 
            Keep = [Keep,i];
            KeepGraphs(i).G = Gnew; 
        end

    end

    if ~isempty(Queue)
        disp(['Removed graphs: ',num2str(length(Queue)-length(Keep))]);
        Queue = Queue(Keep);
    end
    
    end

end