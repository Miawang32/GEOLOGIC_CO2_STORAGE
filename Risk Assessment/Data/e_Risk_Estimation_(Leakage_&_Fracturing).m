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
model_geometry;

load('perm_all.mat', 'num_real'); % we need to load num_real

%% Calculate The Potential of Leakage and Fracturing
grid_volume = G.cells.volumes; % Volume of each grid block
grid_volume_3D = reshape(grid_volume,nx,ny,nz);
% Take a look at the first layer
imagesc(grid_volume_3D(:,:,1))

% Load Saturation Map and Calculate CO2 volume
co2_volume_all = [];
max_pressure_all = [];
for reali = 1:num_real
    load(['result', num2str(reali), '.mat'], 'smap', 'pmap');
    
    %%%% Calculate CO2 Volume in the Top Layer %%%%
    Sat_end = smap(:,end); % we only need the last time step
    Sat_3D = reshape(Sat_end,nx,ny,nz);
    co2_volume_3D = Sat_3D.*grid_volume_3D;
    % Only keep the top layer
    co2_volume_top = co2_volume_3D(:,:,1);
    % Sum them up
    co2_volume_reali = sum(co2_volume_top, "all");
    co2_volume_all = [co2_volume_all; co2_volume_reali];

    %%%% Calculate The Maximum Pressure %%%%
    P_end = pmap(:,end); % we only need the last time step
    P_3D = reshape(P_end,nx,ny,nz);
    %maxP_layers = squeeze(max(P_3D, [], [1,2]));
    max_pressure_reali = max(P_3D, [], "all");
    max_pressure_all = [max_pressure_all; max_pressure_reali];
end

%% Plot The Histogram of Potential of Leakage and Fracturing
figure('Position', [0,0,400,300])
histogram(co2_volume_all, 10)
xlabel('CO2 Volume (m^3)')
ylabel('Count')
print('-dpng', '-r100', 'Leakage_Potential.png')

figure('Position', [0,0,400,300])
histogram(max_pressure_all, 10)
xlabel('Max Pressure (kPa)')
ylabel('Count')
print('-dpng', '-r100', 'Fracture_Potential.png')

%%
figure('Position', [100,100,300,250])
scatter(max_pressure_all, co2_volume_all, 'blue', ...
    'filled')
xlabel('Max Pressure (kPa)')
ylabel('CO2 Volume (m^3')

