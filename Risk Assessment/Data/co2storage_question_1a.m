clc
clear
close all
path_to_mrst = '\your_path_to_mrst\mrst-2022b';
addpath(path_to_mrst);
startup;

%% Dimension and Grid
% Make 3D prism grid with cells refined towards the top
z_res = 15;   % number of cells in depth direction (z)
l_res = 31;   % number of cells in lateral direction (x and y)
nx = l_res; ny = l_res; nz = z_res;
num_grid = l_res*l_res*z_res;

%% Permeability and Porosity
poro = repmat(0.25, num_grid, 1);
perm = repmat(250*milli*darcy, num_grid, 1);
co2poromean=mean(perm)
co2permmean=mean(poro)
%% Well Configuration 
Inj_I = 16; % [8, 10]; % injectors' location in x-axis
Inj_J = 16; % [8, 10]; % injectors' location in y-axis
Inj_RATE = 1.0; % [0.5, 0.5]; % mega-ton/year;

save("well_configuration.mat", "Inj_RATE", "Inj_J", "Inj_I")

%% Model Setup
model_setup;

%% Plot Reservoir
plot_perm; % plot permeability
print('-dpng','-r100', 'perm_map.png');
plot_poro; % plot porosity
print('-dpng','-r100', 'poro_map.png');

%% Run Simulation 
run_simulation;

%% Visualize the CO2 Saturation Distribution
plot_plume_animation; 
plot_plume;
print('-dpng','-r100', 'plume.png');

%% 
plot_resol;
%% 





