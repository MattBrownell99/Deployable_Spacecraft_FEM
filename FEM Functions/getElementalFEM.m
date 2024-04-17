% This function obtains the elemental Mass and Stiffness Matrices and
% Forcing Vector for a membrane. Inputs are [elemental width, elemental height, elemental density, and elemental Stiffness per unit length]
% and the output is the elemental Struct.
function Se = getElementalFEM(a_e,b_e,rho,P)
    
    Se = struct;
    Se.a_e = a_e;
    Se.b_e = b_e;
    Se.rho = rho;
    Se.P = P;
    syms x y
    
    %Get relevant variables for single element stiffness/mass matrix calculation
    [phi, phi_f] = getAssumedModes();       %Get shape functions Phi(x,y)
    [Se.phi_nodes,Se.phi_nodes_f,Se.BC_check,Se.nodes_e] = getphi_nodes(phi_f,phi,a_e,b_e);      %Shape function and derivatives (angles) evaluted at nodes [Phi(xi,yi); Phi_y(xi,yi); -Phi_x(xi,yi)] i = 1:4
    
    %Create 12x1 vectors of phi, phi_x, and phi_y
    phi_vec = Se.phi_nodes(:);
    phix_vec = diff(phi_vec,x);
    phix_vec = phix_vec(:);
    phiy_vec = diff(phi_vec,y);
    phiy_vec = phiy_vec(:);
    
    %Get elemental stiffness/mass matrices and Forcing vector
    Se.Me = double(int(int(rho*(phi_vec*phi_vec.'),x,0,a_e),y,0,b_e));
    Se.Ke = double(int(int(P*(phix_vec*phix_vec.' + phiy_vec*phiy_vec.'),x,0,a_e),y,0,b_e));
    Se.Fe = double(int(int(phi_vec,x,0,a_e),y,0,b_e));
    
end