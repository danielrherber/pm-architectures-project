%--------------------------------------------------------------------------
% plotDesignBio.m
% Custom plotting function using the biograph viewer
% Particularly useful for unconnected graphs
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function plotDesignBio(A,L)

    for j = 1:length(L)
        mylabels(j) = strcat(L(j),num2str(j));
    end

    bg = biograph(tril(A,-1),mylabels);  % make biograph object
    
    set(bg,'ShowArrows','off','LayoutScale',0.5)
    set(bg,'LayoutType','equilibrium')

    dolayout(bg); 
    view(bg);

end