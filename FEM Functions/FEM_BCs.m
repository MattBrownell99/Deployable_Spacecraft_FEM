function S = FEM_BCs(S,BC_type)
    
    %Apply BCs and Calc new system matrix/accel vector
    if BC_type ~= "Tension"
        S.K_bc = applyBCs(S.K,S.nodes_BC,BC_type);
        S.M_bc = applyBCs(S.M,S.nodes_BC,BC_type);
        S.F_bc = applyBCs(S.F,S.nodes_BC,BC_type);
    else
        S.K_bc = applyBCs(S.K,S.nodes_BC,BC_type);
        S.M_bc = S.M;
        S.F_bc = S.F;
    end
    S.A_bc = -S.M_bc\S.K_bc;
    S.Accel_bc = S.M_bc\S.F_bc;
    
    %Calc system matrix with total state vector (x x-dot) for analysis purposes
    S.A_bc_totsys = [zeros(size(S.A_bc)) eye(size(S.A_bc))
                    S.A_bc zeros(size(S.A_bc))];
    
    %get natural freq (imaginary part of eigenvalue of total system matrix)
    temp = eig(S.A_bc_totsys);
    S.freq = [];
    k = 1;
    for i = length(temp):-1:1
        if imag(temp(i)) > 0
            S.freq(k) = imag(temp(i));
            k = k + 1;
        end
    end
    S.freq = sort(S.freq,'ascend');
    
end