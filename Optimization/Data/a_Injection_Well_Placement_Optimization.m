clc
clear
close all
path_to_mrst = '\your_path_to_mrst\mrst-2022b';
addpath(path_to_mrst);
startup;
%%% index of run
indexWms = 4;
%% Dimension and Grid
% Make 3D prism grid with cells refined towards the top
z_res = 15;   % number of cells in depth direction (z)
l_res = 31;   % number of cells in lateral direction (x and y)
nx = l_res; ny = l_res; nz = z_res;
num_grid = l_res*l_res*z_res;
interval = [31, 31, 1]; 

%% Well Configuration 
%%%%  Update the injection locations %%%%
Inj_I = [10, 30]; % 16; % injectors' location in x-axis
Inj_J = [2, 15]; % 16; % injectors' location in y-axis

Inj_RATE = [0.5, 0.5]; % 1.0; % mega-ton/year;


%% Permeability and Porosity
%%%%  Use your updated permeability from previous question %%%%
load updated_perm
%updated_perm = []; % 15-by-1 vector
perm = expand_into_grid(updated_perm, interval, nx, ny, nz);
poro = repmat(0.25, num_grid, 1);

%% Model Setup
model_setup;

%% Run simulation
run_simulation;

%% Collect well solutions
[pmap, smap] = collect_states(states, steps);
[P_well, Qs_well, Qr_well] = collect_welldata(wellSols, steps);

%% Save Your Well Results
%%%% save your data below %%%%
save('Q3a_result.mat', ...
    'P_well', 'Qs_well', 'Qr_well', 'pmap', 'smap')

%% Calculate Risks
%%%% Write your code here %%%%
%% Calculate The Potential of Leakage and Fracturing
grid_volume = G.cells.volumes; % Volume of each grid block
grid_volume_3D = reshape(grid_volume,nx,ny,nz);
% Take a look at the first layer
imagesc(grid_volume_3D(:,:,1))

% Load Saturation Map and Calculate CO2 volume
load ('Q3a_result.mat','smap','pmap')
%co2_update_volume = [];


    %%%% Calculate CO2 Volume in the Top Layer %%%%
    Sat_update_end = smap(:,end); % we only need the last time step
    Sat_update_3D = reshape(Sat_update_end,nx,ny,nz);
    co2_update_volume_3D = Sat_update_3D.*grid_volume_3D;
    % Only keep the top layer
    co2_update_volume_top = co2_update_volume_3D(:,:,1);
    % Sum them up
    co2_update_volume = sum(co2_update_volume_top, "all");
   
%max_update_pressure = [];
    %%%% Calculate The Maximum Pressure %%%%
    P_update_end = pmap(:,end); % we only need the last time step
    P_update_3D = reshape(P_update_end,nx,ny,nz);
    %maxP_layers = squeeze(max(P_3D, [], [1,2]));
    max_update_pressure = max(P_update_3D, [], "all");
%% %% Plot Reservoir
plot_perm; % plot permeability
print('-dpng','-r100', 'perm_udLocation_map.png');
indexWMs = ['perm_udLocation_map_' num2str(indexWms)];
saveas(gcf,[indexWMs, '.png'])
%% Visualize the CO2 Saturation Distribution
plot_plume_animation; 
plot_plume;
print('-dpng','-r100', 'plume_udLocation.png');
indexWMs = ['plume_udLocation_' num2str(indexWms)];
saveas(gcf,[indexWMs, '.png'])
