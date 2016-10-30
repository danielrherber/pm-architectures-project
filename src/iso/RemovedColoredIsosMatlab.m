%--------------------------------------------------------------------------
% RemovedColoredIsosMatlab.m
% Given a set of colored graphs, determine the set of nonisomorphic colored
% graphs, MATLAB only implementation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [FinalGraphs,typearray] = RemovedColoredIsosMatlab(Graphs,opts)

if opts.dispflag
    disp('Now checking graphs for uniqueness...')
    tic % start timer
end

n = length(Graphs); % number of graphs to check
if n < 2000 % parallel computing would be slower
   opts.paralleltemp = 0; 
else
   opts.paralleltemp = opts.parallel; 
end
typearray =  zeros(n,1);
Nbin = 1; % number of cores
v = zeros(1,n); v(1) = 1;
ind = 1;
bin = cell(1,Nbin); % initialize bins
% iso = cell(1,Nbin);

% compute various metrics once
pylists = cell(n,1);
colors = pylists;
nnodes = zeros(n,1);
sumadj = nnodes;
parfor (i = 1:n, opts.paralleltemp)
    adj = Graphs{i}.A;
    nnodes(i) = size(adj,1);
    colors{i} = uint64(Graphs{i}.Ln);
    sumadj(i) = sum(adj(:));
    pylists{i} = int8(adj(:)');
end

for i = 1:n
    adj = Graphs{i}.A;
    G{i} = graph(adj);
    G{i}.Nodes.Color = (Graphs{i}.Ln)';
end

% first graph is always unique
unique_ind = 1; % uniqueness vector, 1 is unique
bin{1}.Graphs{1}.A = Graphs{1}.A;
bin{1}.Graphs{1}.L = Graphs{1}.L;
bin{1}.Graphs{1}.Ln = Graphs{1}.Ln;
bin{1}.Graphs{1}.N = Graphs{1}.N;
bin{1}.Graphs{1}.removephi = Graphs{1}.removephi;
bin{1}.Graphs{1}.pylist = pylists{1};
bin{1}.Graphs{1}.nnode = nnodes(1);
bin{1}.Graphs{1}.colors = colors{1};
bin{1}.Graphs{1}.sumadj = sumadj(1);
bin{1}.Graphs{1}.G = G{1};   

% check remaining graphs for uniqueness
dispstat('','init') % Initialization. Does not print anything.
Ndispstat = floor((n-1)/100);
for i = 2:n
    G1 = G{i};
    nnode1 = nnodes(i);
    color1 = colors{i};
    pyadj1 = pylists{i};
    sumadj1 = sumadj(i);
    
% 	parfor (c = 1:min(Nbin,ind), Nbin) % this works now but is slow        
	for c = 1:min(Nbin,ind)
        j = length(bin{c}.Graphs);
        IsoFlag = 0;
        while (j > 0) && (IsoFlag == 0)
            G2 = bin{c}.Graphs{j}.G;
            IsoFlag = isisomorphic(G1,G2,'NodeVariables','Color');
            j = j - 1;
        end
        results(c) = IsoFlag;
	end
    if any(results) % not unique
        v(i) = 0;
    else
        v(i) = 1;
        J = mod(ind, Nbin) + 1;
        
        if (ind + 1 <= Nbin)
            bin{J}.Graphs{1}.A = Graphs{i}.A;
            bin{J}.Graphs{1}.L = Graphs{i}.L;
            bin{J}.Graphs{1}.Ln = Graphs{i}.Ln;
            bin{J}.Graphs{1}.N = Graphs{i}.N;
            bin{J}.Graphs{1}.removephi = Graphs{i}.removephi;
            bin{J}.Graphs{1}.pylist = pyadj1;
            bin{J}.Graphs{1}.nnode = nnode1;
            bin{J}.Graphs{1}.colors = color1;        
            bin{J}.Graphs{1}.sumadj = sumadj1;   
            bin{J}.Graphs{1}.G = G1;   
        else
            bin{J}.Graphs{end+1}.A = Graphs{i}.A;
            bin{J}.Graphs{end}.L = Graphs{i}.L;
            bin{J}.Graphs{end}.Ln = Graphs{i}.Ln;
            bin{J}.Graphs{end}.N = Graphs{i}.N;
            bin{J}.Graphs{end}.removephi = Graphs{i}.removephi;
            bin{J}.Graphs{end}.pylist = pyadj1;
            bin{J}.Graphs{end}.nnode = nnode1;
            bin{J}.Graphs{end}.colors = color1;        
            bin{J}.Graphs{end}.sumadj = sumadj1;   
            bin{J}.Graphs{end}.G = G1;
        end
        
        unique_ind = [unique_ind, i]; 
        
        ind = ind + 1;
    end
    
    if opts.dispflag
        if mod(i,Ndispstat) == 0
            dispstat(['Percentage complete: ',int2str(i/n*100),' %'])
        end
    end
    
end

FinalGraphs = [];
for c = 1:Nbin
   FinalGraphs = [FinalGraphs, bin{c}.Graphs];
end

if opts.dispflag
    ttime = toc; % stop the timer
    disp(['Found ',num2str(length(FinalGraphs)),' unique graphs in ', num2str(ttime),' s'])
end