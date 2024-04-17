function [phi_nodes,phi_nodes_f,BC_check,nodes_e] = getphi_nodes(phi_f,phi,a,b)
    
    syms x y

%     nodes = [0 0;
%              a/2 0;
%              a 0;
%              0 b/2;
%              a/2 b/2;
%              a b/2;
%              0 b;
%              a/2 b;
%              a b];
    nodes = [0 0;
             a 0;
             0 b;
             a b];
    
    %Build matrix of phi/phi_x/phi_y evaluated at each node
    A = [];
    for i = 1:length(nodes)
        phi_node_eval = phi_f(nodes(i,1),nodes(i,2));
        A = [A; phi_node_eval'];
    end
    
    %Solve for coefficents for various BCs
    I = eye(length(nodes));
    for j = 1:length(nodes)
        b = I(:,j);
        C = pinv(A)*b;
        phi_nodes(j,1) = phi.'*C;
    end
    
    %Convert symbolic matrix to function
    phi_nodes_f = matlabFunction(phi_nodes);
    
    %Evaluate above function at nodal points to see if BCs are satisfied
    BC_check = cell(1,length(nodes));
    for i = 1:length(nodes)
        BC_check{i} = phi_nodes_f(nodes(i,1),nodes(i,2));
    end

    %Define nodal index matrix
    m = sqrt(size(nodes,1));
    nodes_e = zeros(m,m);
    k = 1;
    for j = m:-1:1
        for i = 1:m
            nodes_e(j,i) = k;
            k = k+1;
        end
    end
    
end