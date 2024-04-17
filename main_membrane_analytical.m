clc; clear; close all;
addpath(pwd + "\Analytical Plate Solution\")
addpath(pwd + "\FEM Functions\")
Constants;

load('S_50x50.mat')
fhat = 0;
fp = 0;

%% Get analytical matrices
syms x y
phi = getAssumedModes_anal(2,2,a,b);
phi_f = matlabFunction(phi(:));

[M,K,F] = getMKF(phi(:),a,b,fhat,P,rho);
A = -M\K;
F_tot = [zeros(size(F)); M\F];    %append zeros for setup of 2nd order ODE state = [u; u-dot];

%% Analytical solution
q0 = [1;0;0;0];
qd0 = [0;0;0;0];
tspan = 0:0.001:10;

x0 = [q0; qd0];
opts = odeset('RelTol',1e-12,'AbsTol',1e-14);

%Get solution for modal amplitudes
[t,x_anal] = ode45(@(t,x) EOMs_analy(t,tspan(end),x,A,F_tot), tspan, x0, opts);

%Convert from modal amplitudes to [nodal displacement, phi_1, phi_2]
x_anal_FEM = get_nodes(x_anal(:,1:4)',phi_f,S.nodes_xy);

%Plotting
fig_anal = figure();
subplot(2,1,1)
plot(tspan,x_anal(:,1:4))
xlabel('time [s]')
ylabel('q')
title('Modal Amplitude vs Time')
subplot(2,1,2)
plot(tspan,x_anal_FEM)
xlabel('time [s]')
ylabel('Nodal Position')
title('Nodal Displacement vs Time')
sgtitle('Analytical Dynamics')
%% FEM solution

%Get IC of nodes for corresponding modal amplitude
state0 = x_anal_FEM(:,1);

%remove elements corresponding to BCs
BCs_remove = sort(S.nodes_BC,'descend');
for i = 1:length(BCs_remove)
    state0(BCs_remove(i)) = [];
    x_anal_FEM(BCs_remove(i),:) = [];
end

%Integrate FEM equations
u0 = state0;
ud0 = zeros(size(state0));
[x_FEM, states_FEM_fig] = simulate_dynamics(tspan,S.A_bc,u0,ud0,fp*S.Accel_bc);

%% Plot error

FEM_err = figure();

x_FEM_adj = x_FEM(:,1:length(S.A_bc))';

subplot(2,1,1)
p1 = plot(tspan,x_FEM_adj,'r');
hold on;
p2 = plot(tspan,x_anal_FEM,'b');
xlabel('time [s]')
ylabel('Nodal Dispalcement')
legend([p1(1),p2(1)],["FEM Solution","Analytical Solution"])

subplot(2,1,2)
err = x_FEM_adj - x_anal_FEM;
plot(tspan,err)
xlabel('time [s]')
ylabel('FEM Approximation Error')

%% Find natural frequencies
n = length(S.A);
A_tot = [zeros(n,n) eye(n,n)
         S.A zeros(n,n)];
n_bc = length(S.A_bc);
A_bc_tot = [zeros(n_bc,n_bc) eye(n_bc,n_bc)
            S.A_bc zeros(n_bc,n_bc)];
        
freq = imag(eig(A_tot));
freq_bc = imag(eig(A_bc_tot));
for i = length(freq):-1:1
    if freq(i) < 0
        freq(i) = [];
    end
end
for i = length(freq_bc):-1:1
    if freq_bc(i) < 0
        freq_bc(i) = [];
    end
end

fprintf("Unconstrained Freqencies:\n")
fprintf("%d\n",sqrt(freq))
fprintf("BC Freqencies:\n")
fprintf("%d\n",sqrt(freq_bc))





