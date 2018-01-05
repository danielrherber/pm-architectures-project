function [P,C,R,NSC,order] = Structured_ShuffleGraph(P,B,R,C,NSC)
        if isfield(NSC,'Bind')
            Letters = C(NSC.Bind);
        end
        StructuredIdx = 1:length(B);
        StructuredIdx = StructuredIdx(B==1);
        order = randperm(length(StructuredIdx));
        order = [find(B==0) StructuredIdx(order)];
        P = P(order); C = C(order);
        if ~isfield(R,'min') && ~isfield(R,'max')
           R = R(order); 
        end
        
        NSC.A = NSC.A(:,order);
        NSC.A = NSC.A(order,:);
        if isfield(R,'min')
           R.min = R.min(order); 
        end
        
        if isfield(R,'max')
           R.max = R.max(order); 
        end
        if isfield(NSC,'Bind')
            for i = 1:length(NSC.Bind).*length(NSC.Bind(:,1))
               NSC.Bind(i) = find([C{:}] ==  Letters{i});
            end
        end
end