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

%% Define well configuration
load('well_configuration.mat');

%% Load your realization
load('perm_all.mat');

%%%% Your for loop should start from here %%%%
% for reali = 1:num_real 

%reali = 1 
for reali = 1:num_real
perm = expand_into_grid(perm_all(:,reali), interval, nx, ny, nz);
poro = 0.2*ones(nx*ny*nz,1);

%% Model Setup and Run simulation
model_setup; 
run_simulation;

%% Plot reservoir solution and save figure as .png file
plot_perm; % plot permeability
title(['Realization ', num2str(reali)])
% save your figure as .png file
filename = ['PB1_C_Realization_', num2str(reali), '.png'];
print('-dpng','-r100', filename);

%% Collect your results

[pmap, smap] = collect_states(states, steps);
[P_well, Qs_well, Qr_well] = collect_welldata(wellSols, steps);

%%%% save your data below %%%%
save(['result', num2str(reali), '.mat'], ...
     'pmap', 'smap', 'P_well', 'Qs_well', 'Qr_well')

%%%% end your for loop here %%%%
end