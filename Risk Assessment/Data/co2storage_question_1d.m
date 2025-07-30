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

%% Define the Location of Observation Well
% Location of the Observation Wells
Obs_I = [14, 14, 18, 18];
Obs_J = [14, 18, 14, 18];
Obs_K = [10, 10, 10, 10];
obs = [];
for Jj = 1:numel(Obs_I)
    oi = sub2ind([l_res, l_res, z_res], ...
        Obs_I(Jj), Obs_J(Jj), Obs_K(Jj));
    obs = [obs; oi];
end

save('Observation_Well.mat', 'obs', 'Obs_I', 'Obs_J', 'Obs_K' )

%% Load the Location of Injection Well
load('well_configuration.mat')
wc = []; 
for Ii =1:numel(Inj_I)
    wi = sub2ind([l_res, l_res, z_res], ...
            Inj_I(Ii), Inj_J(Ii), z_res);
end

%% Combine the Locations of Injection and Observation Wells
locations = [wi; obs]; 

%% Load Data for Observation and Injection Wells
load('perm_all.mat');
num_step = 13; 
num_inj = numel(Inj_I); % number of injection wells
num_obs = numel(Obs_I); % number of observation wells

% Create a 3D matrix with dimension of (num_real, num_step, num_well)
% of which all the elements starting to be zeros.
% For example, T_well_3D = zeros(num_real, num_step, num_well)

BHP_well_3D = zeros(num_step, num_inj, num_real);
S_well_3D = zeros(num_step, num_inj+num_obs, num_real);
P_well_3D = zeros(num_step, num_inj+num_obs, num_real);

% Then, load the results of all realizations and store the results 
% in the pre-defined 3D matrix.
for reali = 1:num_real
    load(['result', num2str(reali), '.mat']);
    BHP_well_3D(:,:,reali) = P_well;
    S_well_3D(:,:,reali) = smap(locations,:)';
    P_well_3D(:,:,reali) = pmap(locations,:)';
end

%% Save your collected 3D data
% You must save the following data
% otherwise you might face errors in the next question.
save("result_all.mat", "P_well_3D", "BHP_well_3D", "S_well_3D", ...
    "num_inj", "num_obs", "num_step")

%% Plot your ensemble results
% You need to use the code below to plot pressure, saturation for
% all injection and observation wells in different figures.

%% Plot BHP for Injection Well Only
%%%% Here is an example for plotting BHP %%%%
figure('Position', [0,0,800,500])

for welli = 1:num_inj
subplot(1,1,welli)
plot(squeeze(BHP_well_3D(:,welli,:)), 'Color', [.5, .5, .5], 'LineWidth', 1)
% title(wellnames(welli));
ylabel('BHP (kPa)')
xlabel('Step (Every Six Month)')
end
print('-dpng', '-r100', 'BHP_WELL_ALL.png')

%% Plot Pressure for Both Injection and Observation Wells
wellnames = ["I1", "O1", "O2", "O3", "O4"];

%%%% Here is an example for plotting Pressure %%%%
figure('Position', [0,0,800,500])
for welli = 1:num_inj+num_obs
subplot(2,3,welli)
plot(squeeze(P_well_3D(:,welli,:)), 'Color', [.5, .5, .5], 'LineWidth', 1)
title(wellnames(welli));
ylabel('Pressure (kPa)')
xlabel('Step (Every Six Month)')
end
print('-dpng', '-r100', 'P_WELL_ALL.png')

%% Plot Saturation for Both Injection and Observation Wells
wellnames = ["I1", "O1", "O2", "O3", "O4"];

figure('Position', [0,0,800,500])
%%%% Write Your Code Below %%%%
for welli = 1:num_inj+num_obs
    subplot(2,3,welli)
    plot(squeeze(S_well_3D(:,welli,:)),'color',[.5,.5,.5],'LineWidth',1)
    title(wellnames(welli));
    ylabel('Saturation(%)')
    xlabel('Step (Every Six Month)')
end
print('-dpng', '-r100', 'S_WELL_ALL.png')
