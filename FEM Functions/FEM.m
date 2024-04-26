function S = FEM(Se,Ne)

    S = struct;
    
    S.Se = Se;
    
    %Initialize matrices and vectors
    S.Ke = Se.Ke;
    S.Me = Se.Me;
    S.Fe = Se.Fe;
    
    %Get augmented matices and save
    [S.K, S.nodes] = Augment(S.Ke,Ne,Se.nodes_e);
    [S.M, ~] = Augment(S.Me,Ne,Se.nodes_e);
    [S.F,~] = Augment(S.Fe,Ne,Se.nodes_e);
    S.Accel = S.M\S.F;
    S.A = -S.M\S.K;

    %Calc system matrix with total state vector (x x-dot) for analysis purposes
    S.A_totsys = [zeros(size(S.A)) eye(size(S.A));
                             S.A zeros(size(S.A))];
    
    %Define cell matrix that has xy coords of nodes of each element
    S.nodes_xy = cell(size(S.nodes));
    x_vec = 0:Se.a_e:Ne*Se.a_e;
    y_vec = 0:Se.b_e:Ne*Se.b_e;
    for i = length(x_vec):-1:1
        for j = 1:length(y_vec)
            S.nodes_xy{i,j} = [y_vec(j), x_vec(length(x_vec)-i+1)];
        end
    end
    
%     %Define cell matrix that has xy coords of nodes of each element
%     S.nodes_xy = cell(size(S.nodes));
%     x_vec = 0:Se.a_e/2:Ne*Se.a_e;
%     y_vec = 0:Se.b_e/2:Ne*Se.b_e;
%     for i = length(x_vec):-1:1
%         for j = 1:length(y_vec)
%             S.nodes_xy{i,j} = [y_vec(j), x_vec(length(x_vec)-i+1)];
%         end
%     end
    
    
end