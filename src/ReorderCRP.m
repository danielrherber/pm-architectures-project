%--------------------------------------------------------------------------
% ReorderCRP.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [P,R,C,NSC] = ReorderCRP(P,R,C,NSC,opts)

    % ensure column vectors
    P = P(:);
    R = R(:);

    switch opts.algorithm

        case 'tree_v5' % sort P largest to smallest
             [~,I] = sort(R + P*1000,'descend');

        otherwise % sort P smallest to largest
             [~,I] = sort(R + P*1000,'ascend');

    end

    % order the other items
    P = P(I);
    R = R(I);
    C = C(I);
    NSC.necessary = NSC.necessary(I);
    NSC.A = NSC.A(I,:);
    NSC.A = NSC.A(:,I);
    


end

% notes on the formula
% R + P*1000
% weight number of ports the highest
% but also sort by replicate number


% P = flipud(P);
% R = flipud(R);
% C = fliplr(C);
% NSC.necessary = fliplr(NSC.necessary);
% NSC.A = rot90(NSC.A,2);