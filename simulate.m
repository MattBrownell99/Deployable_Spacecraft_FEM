%% Main script for simulating dynamics of FEM model (run main files first!)
clc; clear; close all;
addpath(pwd + "\FEM Functions")

load('S_5x5.mat')
A = S.A_bc;
F = S.Accel_bc;

response_type = "Forced";
%response_type = "IC";

%Define timespan
h= 0.001;
tf= 10;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
tspan = 0:h:tf;

%Constant (per element) distibuted pressure on element
fp_val = 1e-3;
%IC value (can be constant or different per node)
w0_val = 1e-3;

%%

%Initialize ICs (add in nonzero later if desired)
w0 = zeros(size(S.A,1),1);    
wd0 = zeros(size(S.A,1),1);

%Set ICs/forcing depending on experiment type
if response_type == "IC"
    w0 = w0_val*ones(size(S.A,1),1);
    wd0 = zeros(size(S.A,1),1);
    fp = 0;
elseif response_type == "Forced"
    w0 = zeros(size(S.A,1),1);
    wd0 = zeros(size(S.A,1),1);
    fp = fp_val;
else
    fprintf('idiot type it better')
    return
end

%Check if BCs were applied
if size(A,1) ~= size(S.A,1)
    w0 = applyBCs(w0,S.nodes_BC,"Pinned");
    wd0 = applyBCs(wd0,S.nodes_BC,"Pinned");
end

%Integrate EOMs
[x, states_fig] = simulate_dynamics(tspan,A,w0,wd0,fp*F);


