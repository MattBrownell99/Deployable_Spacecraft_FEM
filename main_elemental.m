%% This script obtains the general form of the mass/stiffness matrices 
%  and forcing vector (assuming constant pressure on an element)
%  Matt Brownell 2-29-24
%format shortEng
clc; clear; close all;
addpath(pwd + "\Local Coords Functions\")
addpath(pwd + "\FEM Functions\")
Constants;

%% Get elemental matrices/vectors functions

syms x y

%Get relevant variables for single element stiffness/mass matrix calculation
[phi, phi_f] = getAssumedModes();       %Get shape functions Phi(x,y)
[phi_nodes,phi_nodes_f,BC_check,nodes_e] = getphi_nodes(phi_f,phi,a,b);      %Shape function and derivatives (angles) evaluted at nodes [Phi(xi,yi); Phi_y(xi,yi); -Phi_x(xi,yi)] i = 1:4

%Create 12x1 vectors of phi, phi_x, and phi_y
phi_vec = phi_nodes(:);
phix_vec = diff(phi_vec,x);
phix_vec = phix_vec(:);
phiy_vec = diff(phi_vec,y);
phiy_vec = phiy_vec(:);

%Get elemental stiffness/mass matrices and Forcing vector
Me = double(int(int(rho*(phi_vec*phi_vec.'),x,0,a),y,0,b));
Ke = double(int(int(P*(phix_vec*phix_vec.' + phiy_vec*phiy_vec.'),x,0,a),y,0,b));
Fe = double(int(int(phi_vec,x,0,a),y,0,b));

%% Parameters for simulation of element dynamics
fp_val = 1e-6;
IC_val = 1e-6;

h = 0.001;
tf = 10;
tspan = 0:h:tf;
exp_type = "Forced";
%exp_type = "IC";

%% %Integrate EOMs for free nodes

if exp_type == "Forced"
    fp = fp_val;
    w0 = zeros(size(Me,1),1);
    wd0 = zeros(size(Me,1),1);
else
    fp = 0;
    w0 = IC_val*ones(size(Me,1),1);
    wd0 = zeros(size(Me,1),1);
end

A = -Me\Ke;
Accel = Me\(fp*Fe);

[x_free, states_fig_free] = simulate_dynamics(tspan,A,w0,wd0,Accel);

%% Integrate EOMs for 2 nodes clamped
nodes_BC = [1 2];

nodes_BC = sort(nodes_BC,'descend');
A_bc = applyBCs(A,nodes_BC);
Accel_bc = applyBCs(Accel,nodes_BC);
% Me_bc = applyBCs(Me,nodes_BC);
% Ke_bc = applyBCs(Ke,nodes_BC);
% Fe_bc = applyBCs(Fe,nodes_BC);
% A_bc = -Me_bc\Ke_bc;
% Accel_bc = Me_bc\Fe_bc;

w0_bc = applyBCs(w0,nodes_BC);
wd0_bc = applyBCs(wd0,nodes_BC);

[x_bc, states_fig_bc] = simulate_dynamics(tspan,A_bc,w0_bc,wd0_bc,Accel_bc);

%% Eigenvalue Comparison between the free and clamped response

n = length(w0);
A_tot = [zeros(n,n) eye(n,n)
         A zeros(n,n)];
n_bc = length(w0_bc);
A_bc_tot = [zeros(n_bc,n_bc) eye(n_bc,n_bc)
            A_bc zeros(n_bc,n_bc)];

EV_fig = figure();
p1 = plot(eig(A_tot),'bx');
hold on;
p2 = plot(eig(A_bc_tot),'ro');
xline(0,'--')
yline(0,'--')
legend([p1, p2],{'No BCs','Clamped Nodes 1 and 2'},'Location','EastOutside')
xlabel('Real')
ylabel('Im')
title('A_{total} Eigenvalues With/Without BCs')
