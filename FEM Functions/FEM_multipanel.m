%Function for building FEM model of multiple panels
function S = FEM_multipanel(S,nx,ny)
    
    Constants;
    S.panel_num = [nx, ny];
    
    %Create block-diagonal matrix and concatinated F vector of all multi panels
    Mr = repmat({S.M_bc},1,nx*ny);
    Kr = repmat({S.K_bc},1,nx*ny);
    S.M_multipanel = blkdiag(Mr{:});
    S.K_multipanel = blkdiag(Kr{:});
    S.F_multipanel = repmat(S.F_bc,nx*ny,1);
    
    %Define new total nodes. Cell of matrices for each panel.
    k = 1;
    for i = 1:nx
        for j = ny:-1:1
            S.nodes_multipanel{j,i} =  S.nodes + (k-1)*size(S.nodes,1)*size(S.nodes,2)*ones(size(S.nodes));
            k = k+1;
        end
    end

    %Use new total nodes to obtain the interconnected nodes' indices
    %'_vert' and '_horiz' are middle of side of panel on all four sides,
    %and '_diag' is the corners of adjacent panels
    inter_nodes_vert = [];
    inter_nodes_horiz = [];
    inter_nodes_diag = [];
    for i = 1:nx
        for j = ny:-1:1
            if j ~= 1
                inter_nodes_vert =  [inter_nodes_vert; [S.nodes_multipanel{j,i}(1,ceil(end/2)) S.nodes_multipanel{j-1,i}(end,ceil(end/2))]];
            end
            if i ~= nx
                inter_nodes_horiz =  [inter_nodes_horiz; [S.nodes_multipanel{j,i}(ceil(end/2),end) S.nodes_multipanel{j,i+1}(ceil(end/2),1)]];
                if j == ny && length(S.nodes_BC) > 4
                    inter_nodes_diag =  [inter_nodes_diag; [S.nodes_multipanel{j,i}(1,end) S.nodes_multipanel{j-1,i+1}(end,1)]];
                elseif j == 1 && length(S.nodes_BC) > 4
                    inter_nodes_diag =  [inter_nodes_diag; [S.nodes_multipanel{j,i}(end,end) S.nodes_multipanel{j+1,i+1}(1,1)]];
                elseif j ~= ny && j ~= 1 && length(S.nodes_BC) > 4
                    inter_nodes_diag =  [inter_nodes_diag; [S.nodes_multipanel{j,i}(1,end) S.nodes_multipanel{j-1,i+1}(end,1)]];
                    inter_nodes_diag =  [inter_nodes_diag; [S.nodes_multipanel{j,i}(end,end) S.nodes_multipanel{j+1,i+1}(1,1)]];
                end
            end
        end
    end
    S.inter_nodes = [inter_nodes_vert;inter_nodes_horiz;inter_nodes_diag];
    
    %Add '-T/L' at each interconnected nodes' entry in the stiffness matrix
    for i = 1:size(S.inter_nodes,1)
        S.K_multipanel(S.inter_nodes(i,1),S.inter_nodes(i,2)) = S.K_multipanel(S.inter_nodes(i,1),S.inter_nodes(i,2)) - (T/L);
        S.K_multipanel(S.inter_nodes(i,2),S.inter_nodes(i,1)) = S.K_multipanel(S.inter_nodes(i,2),S.inter_nodes(i,1)) - (T/L);
    end

    %Calculate system matrix and acceleration vector
    S.A_multipanel = -S.M_multipanel\S.K_multipanel;
    S.Accel_multipanel = S.M_multipanel\S.F_multipanel;

    %Calc system matrix with total state vector (x x-dot) for analysis purposes
    S.A_multipanel_totsys = [zeros(size(S.A_multipanel)) eye(size(S.A_multipanel));
                             S.A_multipanel zeros(size(S.A_multipanel))];

    %get natural freq (imaginary part of eigenvalue of total system matrix)
    temp = eig(S.A_multipanel_totsys);
    S.multi_freq = [];
    k = 1;
    for i = length(temp):-1:1
        if imag(temp(i)) > 0
            S.multi_freq(k) = imag(temp(i));
            k = k + 1;
        end
    end
    S.multi_freq = sort(S.multi_freq,'ascend');

end