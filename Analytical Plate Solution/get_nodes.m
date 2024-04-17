function FEM_states = get_nodes(q,phi_f,nodes_location)
    
    FEM_states = zeros(size(nodes_location,1)*size(nodes_location,2),size(q,2));
    
    m = 1;
    for j = 1:size(nodes_location,1)
        for i = size(nodes_location,2):-1:1
            x = nodes_location{i,j}(1);
            y = nodes_location{i,j}(2);
            phi = phi_f(x,y);
            for t = 1:size(q,2)
                FEM_states(m,t) = FEM_states(m,t) + q(:,t)'*phi;
            end
            m = m + 1;
        end
    end
    
end