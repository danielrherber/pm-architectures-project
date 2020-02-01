%--------------------------------------------------------------------------
% PMA_FixParentPointers.m
% Fix order of parent pointers vector in representing a tree graph
%--------------------------------------------------------------------------
% Takes a vector of parent nodes for an elimination tree, and re-orders it
% to produce an equivalent vector A in which parent nodes are always
% higher-numbered than child nodes
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [a,pv] = PMA_FixParentPointers(parent)

n = length(parent);
a = parent;
a(a==0) = n+1;
pv = 1:n;

niter = 0;
while(1)
   k = find(a<(1:n));
   if isempty(k), break; end
   k = k(1);
   j = a(k);

   % put node k before its parent node j
   a  = [ a(1:j-1)  a(k)  a(j:k-1)  a(k+1:end)];
   pv = [pv(1:j-1) pv(k) pv(j:k-1) pv(k+1:end)];
   t = (a >= j & a < k);
   a(a==k) = j;
   a(t) = a(t) + 1;

   niter = niter+1;
   if (niter>n*(n-1)/2)
     error('not a tree graph');
   end
end

a(a>n) = 0;

end