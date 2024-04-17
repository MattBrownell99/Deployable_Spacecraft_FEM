function A = applyBCs(A,nodes_BC,BC_type)
    
    Constants;
    nodes_BC = sort(nodes_BC,'descend');
    
    if BC_type == "Pinned"
        if size(A,1) > 1 && size(A,2) > 1
            for i = 1:length(nodes_BC)
                A(nodes_BC(i),:) = [];
                A(:,nodes_BC(i)) = [];
            end
        else
            for i = 1:length(nodes_BC)
                A(nodes_BC(i),:) = [];
            end
        end
    elseif BC_type == "Tension"
        if size(A,1) > 1 && size(A,2) > 1
            for i = 1:length(nodes_BC)
                A(nodes_BC(i),nodes_BC(i)) = A(nodes_BC(i),nodes_BC(i)) + (T/L);
            end
        end
    else
        fprintf('nah')
        return
    end
    
end