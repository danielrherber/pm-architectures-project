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
function Queue = PMA_IsoBFS(Queue,Tsort,Ln,Nc,iter,Vsort,dispflag)

    % maximum number of graphs to perform this isomorphism checking procedure
    Ncheck = 1000;

    % sort degrees lists with respect to labels
    [VC,VIA,VIC] = unique(Ln);

    % go through each component type
    for i = 1:length(VC)
        % find all components of the current type
        Ncomp = sum(VIC==i);

        % sort
        Vsort(:,VIA(i):VIA(i)+Ncomp-1) = sort(Vsort(:,VIA(i):VIA(i)+Ncomp-1),2);
    end

    % isomorphism checking method
    IsoFlag = 2;
    switch IsoFlag
        case 1 % matlab implementation
            Queue = MATLABiso(Queue,Tsort,Ln,Nc,iter);
        case 2 % python implementation
            Queue = PYTHONiso(Queue,Tsort,Ln,Nc,iter,Vsort,dispflag,Ncheck);
        otherwise
            error('Unknown isomorphism checking option selected')
    end

end
% python implementation
function Queue = PYTHONiso(Queue,Tsort,Ln,Nc,iter,Vsort,dispflag,Ncheck)

    % check if we should perform the full isomorphism checks
    if length(Queue) < Ncheck

        % first graph is unique
        if ~isempty(Queue)
            Keep = 1;
            Anew = zeros(Nc);
            Anew(Tsort(1,end-iter+1:end)) = 1;
            Anew = Anew + Anew';
            AKeep(:,:,1) = Anew;
            VKeep(1,:) = Vsort(1,:);
            TKeep(:,1) = sort(diag(Anew^3)); % /6, triangle distribution
            % [~, C] = graphconncomp(sparse(Anew), 'Directed', false);
            % CKeep{1} = sort(histcounts(C));
        end

        % go through each graph in the queue
        for i = 2:length(Queue)
            % extract
            Anew = zeros(Nc);
            Anew(Tsort(i,end-iter+1:end)) = 1;
            Anew = Anew + Anew';
            Vnew = Vsort(i,:);
            Tnew = sort(diag(Anew^3)); % /6
            % [~, C] = graphconncomp(sparse(Anew), 'Directed', false);
            % Cnew = sort(histcounts(C));

            % number of graphs in the current bin
            j = length(Keep); 

            % initialize isoFlag
            IsoFlag = 0; 

            while (j > 0) && (IsoFlag == 0)
                % get old graph index
                idx = Keep(j);

                % go through the simple checks
                if isequal(Vnew,VKeep(idx,:)) % should be degree sequences matching with respect to colors
                    if isequal(Tnew,TKeep(:,idx)) % distribution of the numbers of triangles (uncolored)                    
                        % Cold = CKeep{idx};
                        % if isequal(Cnew,Cold) % distribution of the connected components
                            Aold = AKeep(:,:,idx);

                            % check for full isomorphism
                            IsoFlag = py.detectiso_func4.detectiso(Anew,Aold,Ln',Ln',Nc,Nc);
                        % end
                    end
                end

                % go to the next graph             
                j = j - 1;
            end

            % save, graph is unique
            if ~IsoFlag 
                Keep = [Keep,i];
                AKeep(:,:,i) = Anew; 
                VKeep(i,:) = Vnew;
                TKeep(:,i) = Tnew;
                CKeep{i} = Cnew;
            end
        end

        if ~isempty(Queue)
            % print
            if dispflag > 2 % very verbose
                fprintf('  Removed graphs (Full ISO): %8d\n',length(Queue)-length(Keep))
            end

            % update queue
            Queue = Queue(Keep);
        end

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
% old code
% Vsort = sort(Vstorage(Queue,:),2,'ascend');