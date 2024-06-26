%% Main script for 2.5D FEM of out-of-plane deformation
% This script outputs a structure variable (S) that contains all relevant
% parts for FEM. BCs are also applied if specified. The 'S' variable is
% save in the current filepath for use in the 'simulate.m' file
% 'Constants.m' contains all relevant constant values
% 'main_elemental.m' must be ran beforehand so that relevant
% matrices/vectors can be obtained

clc; clear; close all;
addpath(pwd + "\FEM Functions")
addpath(pwd + "\Local Coords Functions")
Constants;

%Define number of elements in x/y direction
Ne = 2;
a_e = a/Ne;   %width of element
b_e = b/Ne;   %height of element

%% Get and save all relevent FEM variables

%Get singular finite element model
Se = getElementalFEM(a_e,b_e,rho,P);

%Get augmented FEM model
S = FEM(Se,Ne);

%Apply BCs
% BC_type = "Pinned";
% S.nodes_BC = [S.nodes(1, :) S.nodes(end, :) S.nodes(2:(end-1), 1)'  S.nodes(2:(end-1), end)'];
S.BC_type = 'Tension';
%S.nodes_BC = [S.nodes(ceil(end/2),1), S.nodes(ceil(end/2),end), S.nodes(1,ceil(end/2)), S.nodes(end,ceil(end/2))];
S.nodes_BC = [S.nodes(ceil(end/2),1), S.nodes(ceil(end/2),end), S.nodes(1,ceil(end/2)), S.nodes(end,ceil(end/2)),...
              S.nodes(1,1), S.nodes(end,1), S.nodes(1,end), S.nodes(end,end)];    %For having corner tension members too

S = FEM_BCs(S,S.BC_type);

%Append multiple panels together if doing tension BC
S = FEM_multipanel(S,2,2);

%Save structure
save(sprintf('S_%ix%i.mat',Ne,Ne),'S')

%PLoteigenvalues of unconstrained, boundary conditions, and multipanel system matrices
M = cell(1,3);
M{1} = S.A_totsys;
M{2} = S.A_bc_totsys;
M{3} = S.A_multipanel_totsys;
plotEigenvalues(M)















