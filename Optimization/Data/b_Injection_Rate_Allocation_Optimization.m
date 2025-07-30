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
interval = [31, 31, 1]; 

%% Well Configuration 
%%%%  Update the injection location %%%%
Inj_I = [12, 20]; % 16; % injectors' location in x-axis
Inj_J = [12, 20]; % 16; % injectors' location in y-axis

%%%%  Update the injection rates %%%%
Inj_RATE = [0.3, 0.7]; % 1.0; % mega-ton/year;

%% Permeability and Porosity
%%%%  Use your updated permeability from previous question %%%%
load updated_perm.mat
% updated_perm = []; % 15-by-1 vector
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
save('Q3c_result.mat', ...
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
    Sat_udRate_end = smap(:,end); % we only need the last time step
    Sat_udRate_3D = reshape(Sat_udRate_end,nx,ny,nz);
    co2_udRate_volume_3D = Sat_udRate_3D.*grid_volume_3D;
    % Only keep the top layer
    co2_udRate_volume_top = co2_udRate_volume_3D(:,:,1);
    % Sum them up
    co2_udRate_volume = sum(co2_udRate_volume_top, "all");
   
%max_update_pressure = [];
    %%%% Calculate The Maximum Pressure %%%%
    P_udRate_end = pmap(:,end); % we only need the last time step
    P_udRate_3D = reshape(P_udRate_end,nx,ny,nz);
    %maxP_layers = squeeze(max(P_3D, [], [1,2]));
    max_udRate_pressure = max(P_udRate_3D, [], "all");

%% Plot the rate over the times of change ci
figure('Position', [0,0,400,300])
for Inj_RATE_1 = Qr_well(:,1)
plot(Inj_RATE_1,'Color',[.5 .5 .5],'LineWidth',1)

hold on

Inj_RATE_2 = Qr_well(:,2);
plot(Inj_RATE_2,'Color',[.5 .5 .5],'LineWidth',1)
xlabel('year')
ylabel('rate')
end
print('-dpng', '-r100', 'Q3c_Rate.png')
%% Plot 2 risks over the times of change  cii
%%co2
figure('Position', [0,0,800,500])
num_step = numel(steps);
x = 1:num_step;
co2_risk_volume = [];
for sat_risk = pmap(:,x)
 sat_3d = reshape (sat_risk,nx,ny,nz);
 co2_risk_volume_3D = sat_3d.*grid_volume_3D;  
 co2_risk_volume_top = co2_risk_volume_3D(:,:,1);
 co2_risk_volumex = sum(co2_udRate_volume_top, "all");
 co2_risk_volume =[co2_risk_volume,co2_risk_volumex];

%top_grid = squeeze(grid_volume_3D(:,:,1));
%grid_copy = repmat(top_grid,[1,1,13]);
%sat_3d =  reshape(smap,[31,31,15,13]);
%top_sat = squeeze(sat_3d(:,:,1,:));
%co2_risk_volume_3D = top_sat.*grid_copy;
%co2_risk_volume = sum(co2_risk_volume_3D,[1,2]);
%top_sat_3d = squeeze(top_sat);
%co2_risk_volume_3D = top_sat.*grid_copy;
%co2_risk_volume = sum(co2_risk_volume_3D, "all");
end
plot(co2_risk_volume, 'Color', [.5, .5, .5], 'LineWidth', 1);
ylabel('CO2')
xlabel('Year')
print('-dpng', '-r100', 'Q3c_CO2.png')
%% max pressure

figure('Position', [0,0,800,500])
num_step = numel(steps);
y = 1:num_step;
p_risk = [];
for p_risky = pmap(:,y)
    p_risky_3d = reshape(p_risky,nx,ny,nz);
 
    max_p_risk = max(p_risky_3d, [], "all");
    p_risk = [p_risk, max_p_risk];
end

plot(p_risk, 'Color', [.5, .5, .5], 'LineWidth', 1);
ylabel('MaxP')
xlabel('Year')
print('-dpng', '-r100', 'Q3c_MaxP.png')
