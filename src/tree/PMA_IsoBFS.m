%--------------------------------------------------------------------------
% PMA_IsoBFS.m
% Isomorphism checking function for breadth-first search algorithms
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function Queue = PMA_IsoBFS(Queue,Tsort,Ln,Vsort,displevel,Ncheck,isomethod)

Queue = PMA_RemoveIsoLabeledGraphs(Queue,Tsort,Ln,displevel,isomethod);

end

% return
%
% % if no graphs
% if isempty(Queue)
%     return
% end
%
% % if only one graph
% if length(Queue) == 1
%     return
% end
%
% % parse isomorphism method specification
% switch lower(isomethod) % case insensitive
%     %----------------------------------------------------------------------
%     case 0 % don't check for labeled graph isomorphisms
%         if (displevel > 0) % minimal
%             disp('-> no isomorphism checking using the ''none'' option')
%         end
%         return; % exit function
%     %----------------------------------------------------------------------
%     case 1 % matlab implementation
%         method = 1;
%     %----------------------------------------------------------------------
%     case 2 % python implementation
%         method = 2;
%     %----------------------------------------------------------------------
%     otherwise
%         error('Unknown isomorphism checking option selected')
% end
%
% % output to the command window
% if (displevel > 1) % verbose
%     disp('Now checking graphs for uniqueness...')
% end
%
% if method == 2 % python
%     % import isomorphism checking function
%     py.importlib.import_module('detectiso_igraph'); % import module
% end
%
% % number of graphs to check
% n = length(Queue);
%
% % initialize
% [nvertices,nedges] = deal(zeros(n,1,'uint64'));
% [dlabels,dloops,dedges,dtriangles,ddegrees,dconnected,deigenvalues] = deal(cell(n,1));
% if method == 1 % matlab
%    G0 = graph(); % empty graph
%    G = cell(n,1);
% end
% if method == 2 % python
%     pylist = cell(n,1);
% end
%
% % compute various metrics once
% for i = 1:n
%     % adjacency matrix
%     At = zeros(Nc,'double');
%     At(Tsort(i,end-iter+1:end)) = 1;
%     At = At + At';
%
%     % compute metrics
%     nvertices(i) = uint16(size(At,1));
%     nedges(i) = uint16(sum(At(:)));
%     dlabels{i} = uint64(Ln);
%     dedges{i} = uint8(sort(nonzeros(At(:))))';
%     dtriangles{i} = uint16(sort(diag((At-diag(diag(At)))^3)))';
%     ddegrees{i} = uint8(sort(sum(At,1)));
%     dloops{i} = uint16(sort(diag(At)))';
%     deigenvalues{i} = single(eig(At)');
%
%     % add this where appropriate
%
%     cc = PMA_ConnCompBins(At); % determine connected components
%     ncc = max(cc); % number of connected components
%     bins = cell(1,ncc); % initialize
%     for j = 1:ncc % go through each connected component
%         bins{j} = [Ln(cc==j),-1]; % create bin and add spacer
%     end
%     [~,I] = sortrows(Cell2MatrixwithPadding(bins)); % sort bins
%     bins = bins(I); % sort bins
%     dconnected{i} = horzcat(bins{:}); % catenate sorted cc bins
%
%     if method == 1 % matlab
%         % matlab graph object
%         Gt = G0;
%         [I,J] = find(At);
%         Gt = addedge(Gt,I,J);
%         Gt.Nodes.Color = (Ln)';
%         G{i} = Gt;
%     end
%     if method == 2 % python
%         pylist{i} = int8(At(:)');
%     end
% end
%
% if method == 2 % python
%     pydlabels = dlabels; % store unaltered labels for python
% end
%
% % convert cell arrays into matrices
% dedges = Cell2MatrixwithPadding(dedges);
% dlabels = Cell2MatrixwithPadding(dlabels);
% dtriangles = Cell2MatrixwithPadding(dtriangles);
% ddegrees = Cell2MatrixwithPadding(ddegrees);
% dloops = Cell2MatrixwithPadding(dloops);
% dconnected = Cell2MatrixwithPadding(dconnected);
% deigenvalues = Cell2MatrixwithPadding(deigenvalues);
%
% % initialize number of nonisomorphic graphs found
% nNonIso = 0;
%
% % first graph is always unique so store it
% bin = 1;
% nNonIso = nNonIso + 1;
%
% % check remaining graphs for uniqueness
% for i = 2:n
%     % get candidate graph information
%     C_nv = nvertices(i); % number of vertices
%     if method == 1 % matlab
%         C_G = G{i}; % matlab graph object
%     end
%     if method == 2 % python
%         C_pyadj = pylist{i}; % adjacency matrix list
%         C_pydlabels = pydlabels{i}; % labels
%     end
%
%     % initialize
%     IsoFlag = false;
%
%     % extract bin indices
%     Ibin = bin;
%
%     % compare number of edges
%     Ikeep = nedges(Ibin)==nedges(i);
%     Ibin = Ibin(Ikeep);
%
%     % compare number of vertices
%     Ikeep = nvertices(Ibin)==nvertices(i);
%     Ibin = Ibin(Ikeep);
%
%     % compare degree distributions
%     Ikeep = all(ddegrees(Ibin,:)==ddegrees(i,:),2);
%     Ibin = Ibin(Ikeep);
%
%     % compare edge distributions
%     Ikeep = all(dedges(Ibin,:)==dedges(i,:),2);
%     Ibin = Ibin(Ikeep);
%
%     % compare label distributions
%     Ikeep = all(dlabels(Ibin,:)==dlabels(i,:),2);
%     Ibin = Ibin(Ikeep);
%
%     % compare loop distributions
%     Ikeep = all(dloops(Ibin,:)==dloops(i,:),2);
%     Ibin = Ibin(Ikeep);
%
%     % compare triangle distributions
%     Ikeep = all(dtriangles(Ibin,:)==dtriangles(i,:),2);
%     Ibin = Ibin(Ikeep);
%
%     % compare connected component distributions
%     Ikeep = all(dconnected(Ibin,:)==dconnected(i,:),2);
%     Ibin = Ibin(Ikeep);
%
%     % sort based on closest eigenvalue distributions
%     [S,Isort] = sort(vecnorm(deigenvalues(Ibin,:)-deigenvalues(i,:),2,2));
%     Ibin = Ibin(Isort); % sort
%     Ibin(S > 1e-8) = []; % remove spectrum that are very different
%     % https://en.wikipedia.org/wiki/Spectral_graph_theory
%
%     % check no graphs to compare against
%     if isempty(Ibin)
%         bin(end+1) = i; % add to bin
%         nNonIso = nNonIso + 1; % increment since a unique graph was found
%         continue
%     end
%
%     % go through each graph in the bin
%     if method == 2 % python
%         for j = Ibin
%             IsoFlag = py.detectiso_func4.detectiso(C_pyadj,pylist{j},...
%                 C_pydlabels,pydlabels{j},C_nv,nvertices(j));
%             if IsoFlag
%                 break
%             end
%         end
%     elseif method == 1 % matlab
%         for j = Ibin
%             IsoFlag = isisomorphic(C_G,G{j},'NodeVariables','Color');
%             if IsoFlag
%                 break
%             end
%         end
%     end
%
%     % check if the candidate graph is unique
%     if ~IsoFlag % unique
%         % add to bin
%         bin(end+1) = i;
%
%         % increment since a unique graph was found
%         nNonIso = nNonIso + 1;
%     end
%
% end
%
% % print
% if displevel > 2 % very verbose
%     fprintf('  Removed graphs (Full ISO): %8d\n',length(Queue)-length(bin))
% end
%
% % update queue
% Queue = Queue(bin);
%
% end

% error('not finished')
%
%
%
%     % isomorphism checking method
%     switch isomethod
%         case 1 % matlab implementation
%             Queue = MATLABiso(Queue,Tsort,Ln,Nc,iter);
%         case 2 % python implementation
%             Queue = PYTHONiso(Queue,Tsort,Ln,Nc,iter,Vsort,displevel,Ncheck);
%         otherwise
%             error('Unknown isomorphism checking option selected')
%     end
%
% end
% % python implementation
% function Queue = PYTHONiso(Queue,Tin,Ln,Nc,iter,Vin,dispflag,Ncheck)
%
%     % check if we should perform the full isomorphism checks
%     if ~isempty(Queue) && (length(Queue) <= Ncheck)
%
%         % import isomorphism checking function
%         py.importlib.import_module('detectiso_func4'); % import module
%
%         % determine reduced length labels
%         [~,~,VIC] = unique(Ln);
%
%         % bins for histcounts
%         bins = 0:Nc+1;
%
%         % initialize
%         n = length(Queue);
%         A = zeros(Nc,Nc,n,'double');
%         T = zeros(n,Nc,'double');
%         C = zeros(n,Nc+1,'double');
%         S = cell(n,1);
%
%         [dlabels,dloops,dedges,dtriangles,ddegrees,dconnected,deigenvalues] = deal(cell(n,1));
%
%
%         % compute various metrics once
%         for i = 1:n
%             % adjacency matrix
%             At = zeros(Nc,'double');
%             At(Tin(i,end-iter+1:end)) = 1;
%             At = At + At';
%             A(:,:,i) = At;
%
%             % triangle distribution (sorted by color groups)
%             At = At - diag(diag(At)); % remove self-loops (maybe not needed?)
%             Tt = diag(At^3);
%             T(i,:) = Tt; % sort by color later
%
%             % connected components distribution (uncolored)
%             Ct = PMA_ConnCompBins(At); % connected component labeling
%             C(i,:) = sort(histcounts(Ct,bins)); % sort bins
%
%             % connected components distribution (colored)
%             S = cell(1,max(Ct)); % initialize
%             % go through each connected component
%             for k = 1:max(Ct)
%                 % convert to base 36 and sort labels in the connected component
%                 s = sort(dec2base(VIC(Ct==k),36)); % up to 35 unique component labels
%                 % add to list
%                 S{k} = s;
%             end
%             % sort the connected components
%             S{i} = sort(S);
%
%
%             % eigenvalue distribution
%             deigenvalues{i} = single(eig(At)');
%
%         end
%
%         deigenvalues = Cell2MatrixwithPadding(deigenvalues);
%
%         % sort the metrics by color groups
%         V = PMA_ColorBasedSorting(Vin,Ln); % degree distribution
%         T = PMA_ColorBasedSorting(T,Ln); % triangle distribution
%
%         % first graph is unique
%         bin = 1;
%
%         % go through each graph in the queue
%         for q = 2:n
%             % extract bin indices
%             Ibin = bin;
%
%             % get metric for the current graph
%             Atest = A(:,:,q);
%             Vtest = V(q,:);
%             Ttest = T(q,:);
%             Ctest = C(q,:);
%             Stest = S{q};
%
%             % initialize isoFlag
%             IsoFlag = false;
%
%             % compare
%             Ikeep = all(C(Ibin,:)==Ctest,2);
%             Ibin = Ibin(Ikeep);
%
%             % compare
%             Ikeep = all(V(Ibin,:)==Vtest,2);
%             Ibin = Ibin(Ikeep);
%
%             % compare
%             Ikeep = all(T(Ibin,:)==Ttest,2);
%             Ibin = Ibin(Ikeep);
%
%             % sort based on closest eigenvalue distributions
%             [S2,Isort] = sort(vecnorm(deigenvalues(Ibin,:)-deigenvalues(q,:),2,2));
%             Ibin = Ibin(Isort); % sort
%             Ibin(S2 > 1e-8) = []; % remove spectrum that are very different
%             % https://en.wikipedia.org/wiki/Spectral_graph_theory
%
%             % check no graphs to compare against
%             if isempty(Ibin)
%                 bin(end+1) = q;
%                 continue
%             end
%
%
% %             % check some matrix based metrics
% %             Clogical = all(Ctest==C,2);
% %             Vlogical = all(Vtest==V,2); % should be degree sequences matching with respect to colors
% %             Tlogical = all(Ttest==T,2); % distribution of the numbers of triangles with respect to colors
%
% %             % combine
% %             Xlogical = Clogical & Vlogical & Tlogical;
%
%             % go through all potentially isomorphic graphs
%             for i = Ibin % flip(Ibin(Xlogical(Ibin)),2)
%               % go through additional simple checks
%               if isequal(Stest,S{i}) % connected components distribution (colored)
%                 % check for full isomorphism
%                 A2 = A(:,:,i);
%                 IsoFlag = py.detectiso_func4.detectiso(Atest(:),A2(:),Ln,Ln,Nc,Nc);
%                 if IsoFlag
%                   break
%                 end
%               end
%             end
%
%             % save, graph is unique
%             if ~IsoFlag
%                 bin(end+1) = q;
%             end
%         end
%
%         % print
%         if dispflag > 2 % very verbose
%             fprintf('  Removed graphs (Full ISO): %8d\n',length(Queue)-length(Ibin))
%         end
%
%         % update queue
%         Queue = Queue(bin);
%
%     end
%
% end
% % matlab implementation
% % NOTE: this function is not finished, see python implementation above
% function Queue = MATLABiso(Queue,Tsort,Ln,Nc,iter)
%     % first graph is unique
%     if length(Queue) < 10000000
%
%     if ~isempty(Queue)
%         Ibin = 1;
%         Anew  = zeros(Nc);
%         Anew(Tsort(1,end-iter+1:end)) = 1;
%         Gnew = graph(Anew,'lower');
%         Gnew.Nodes.Color = Ln';
%         KeepGraphs(1).G = Gnew;
%     end
%
%     for i = 2:length(Queue)
%
%         Anew  = zeros(Nc);
%         Anew(Tsort(i,end-iter+1:end)) = 1;
%         Gnew = graph(Anew,'lower');
%         Gnew.Nodes.Color = Ln';
%
%         j = length(Ibin); % number of graphs in the current bin
%         IsoFlag = 0; % initialize isoFlag
%
%         while (j > 0) && (IsoFlag == 0)
%
%             idx = Ibin(j);
%             Gold = KeepGraphs(idx).G;
%
%             if isisomorphic(Gnew,Gold,'NodeVariables','Color')
%                 IsoFlag = 1;
%             end
%             j = j - 1;
%         end
%
%         if ~IsoFlag
%             Ibin = [Ibin,i];
%             KeepGraphs(i).G = Gnew;
%         end
%
%     end
%
%     if ~isempty(Queue)
%         disp(['Removed graphs: ',num2str(length(Queue)-length(Ibin))]);
%         Queue = Queue(Ibin);
%     end
%
%     end
%
% end