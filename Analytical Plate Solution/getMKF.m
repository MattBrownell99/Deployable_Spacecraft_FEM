function [M,K,F] = getMKF(phi_vec,a,b,fhat,P,rho)

    syms x y
    
    M = zeros(length(phi_vec));
    K = zeros(length(phi_vec));
    F = zeros(length(phi_vec),1);
    for i = 1:length(phi_vec)
        for j = 1:length(phi_vec)

            temp_M = rho*phi_vec(i)*phi_vec(j);
            M(i,j) = double(int(int(temp_M,x,0,a),y,0,b));
            
            temp_K = -P*(diff(phi_vec(i),x,2) + diff(phi_vec(i),y,2))*(phi_vec(j));
            K(i,j) = double(int(int(temp_K,x,0,a),y,0,b));

        end
        
        F(i) = double(int(int(fhat*phi_vec(i),x,0,a),y,0,b));
        
    end

end