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
model_geometry; % Compute geometry of the model
interval = [31, 31, 1]; 

%% 1. Generate permeability realization
%%%% Define the following variables %%%%
mean_logperm  = -13.5 ;  % mean of permeability for gaussian distribution
sigma_logperm = 0.3 ;  % sigma of permeability for gaussian distribution
num_zone = 15;  % the number of zones
num_real = 20 ;  % the number of realizations

% Sampling the permeability by running the following lines
log10perm = normrnd(mean_logperm, sigma_logperm, num_zone, num_real);
perm_all = 10.^log10perm;
save("perm_all.mat", "perm_all", "num_zone", "num_real", "interval");

%% 2. Plot your realizations
% choose the realization that you want to plot
reali = 2;
perm = expand_into_grid(perm_all(:,reali), interval, nx, ny, nz);
plot_perm; % plot permeability

%% 3. Save your figure as .png file
filename = ['PB1_B_Realization_', num2str(reali), '.png'];
print('-dpng','-r100', filename);