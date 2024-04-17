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
    
%     S.EV_fig = figure();
    
    n = size(S.M,1);
    A = [zeros(n,n) eye(n)
         S.A zeros(n,n)];
    n_bc = size(S.M_bc,1);
    A_bc = [zeros(n_bc,n_bc) eye(n_bc)
            S.A_bc zeros(n_bc,n_bc)];
    
%     subplot(1,2,1)
%     plot(eig(A),'bx');
%     hold on;
%     plot(eig(A_bc),'ro');
%     xline(0,'--')
%     yline(0,'--')
%     xlabel('Real')
%     ylabel('Im')
%     title('Eigenvalues of System Matrix')
%     
%     subplot(1,2,2)
%     p1 = plot(real(eig(A)),'bx');
%     hold on;
%     p2 = plot(real(eig(A_bc)),'ro');
%     ylim([-1 1])
%     xlabel('EV Index')
%     ylabel('Real')
%     title('Real Component')
%     legend([p1, p2], {'A_{Aug}', 'A_{BCs}'})
    
    %get natural freq (imaginary part of eigenvalue of total system matrix)
    temp = eig(A_bc);
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