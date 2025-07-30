clc
clear
close all
path_to_mrst = '\your_path_to_mrst\mrst-2022b';
addpath(path_to_mrst);
startup;


%%% index of run
indexTag = 4;
%% Dimension and Grid
% Make 3D prism grid with cells refined towards the top
z_res = 15;   % number of cells in depth direction (z)
l_res = 31;   % number of cells in lateral direction (x and y)
nx = l_res; ny = l_res; nz = z_res;
interval = [31, 31, 1];
model_geometry;

%% Update Your Permeability 

%%%% Load your best realization here %%%%
% best_perm =   % 15-by-1 array
%% load column#16 from perm_all
load perm_all.mat
best_perm = perm_all(:,16);


%%%% Update the multiplier here %%%%
multiplier = [1 1 1 1 1 ... % Top 5 layers
              1 1 0.7 0.8 2.83 ... % Middle 5 layers
              1 0.7 1.4 6.3 1.05]';  % Bottom 5 layers

updated_perm = multiplier.*best_perm; 
perm = expand_into_grid(updated_perm, interval, nx, ny, nz);
poro = 0.2*ones(nx*ny*nz,1);
plot_perm;
save("updated_perm.mat","updated_perm")

%% Model Setup 
load('well_configuration.mat')
model_setup; 

%% Run simulation
run_simulation;

%% Save Your Well Results
%%%% Write your code here %%%%
[pmap,smap] =collect_states(states,steps);
[P_well, Qs_well, Qr_well] = collect_welldata(wellSols,steps);

save('2d_multipResult.mat','P_well', 'Qs_well','Qr_well','pmap','smap');
%% Calculate and Save Your Mismatch for Question 2d(ii)
%%%% Write your code here %%%% use rmse
% s_update =
[P_upadted, S_updated, BHP_updated] = extract_well_data(P_well, pmap, smap);
P_upadted_truncated = P_upadted(1:5,:); %FIRST 5 STEP OF 6 YEARS* INJ+OBS WELLS
S_upadted_truncated=  S_updated(1:5,:);
BHP_updated_truncated = BHP_updated(1:5,:);
%%vector them
S_update_vector = S_upadted_truncated(:);
P_update_vector = P_upadted_truncated(:);
BHP_update_vector = BHP_updated_truncated(:);

%% load field data
load('Field_data.mat')

%% Convert actual data into one vector (1 column)
S_true_vector = S_well_true(:);
P_true_vector = P_well_true(:);
BHP_true_vector = BHP_well_true(:);

S_trnup_vector = [S_true_vector;S_update_vector];
P_trnup_vector = [P_true_vector;P_update_vector];
BHP_trnup_vector = [BHP_true_vector; BHP_update_vector];

S_trnup_vector_normalized = normalize(S_trnup_vector,"range");
P_trnup_vector_normalized = normalize(P_trnup_vector,"range");
BHP_trnup_vector_normalized = normalize(BHP_trnup_vector,"range");

S_trnup_normalized = reshape(S_trnup_vector_normalized,25,2);
 P_trnup_normalized = reshape(P_trnup_vector_normalized,25,2);
 BHP_trnup_normalized = reshape(BHP_trnup_vector_normalized,5,2);

SPBHP_trnup_vector =[S_trnup_normalized;P_trnup_normalized;BHP_trnup_normalized];
SPBHP_true_vector = [S_trnup_normalized(:,1);P_trnup_normalized(:,1);BHP_trnup_normalized(:,1)];
RMSE = rmse(SPBHP_trnup_vector(:,2),SPBHP_true_vector);


%% Plot BHP 
plot(BHP_updated,'Color',[.5 .5 .5],'LineWidth',1); hold on;
plot(BHP_well_true,'r.', 'MarkerSize',10)
ylabel('BHP(kPa)')
xlabel('Year')

print('-dpng','-r100','Q2d_update_BHP.png')
indexPng = ['Q2d_update_BHP_' num2str(indexTag)];
saveas(gcf,[indexPng, '.png'])
%% Plot Pressure
%P_upadted_truncated
wellnames = ["I1", "O1", "O2", "O3", "O4"];
figure('Position', [0,0,800,500])
for welli = 1:5
subplot(2,3,welli)
plot(P_upadted(:,welli), 'Color', [.5, .5, .5], 'LineWidth', 1);
hold on;
plot(P_well_true(:,welli), 'r.', 'MarkerSize', 10)
title(wellnames(welli))
ylabel('Pore Pressure (kPa)')
xlabel('Year')
end
print('-dpng', '-r100', 'Q2d_update_PWell.png')
indexPng = ['Q2d_update_PWell_' num2str(indexTag)];
saveas(gcf,[indexPng, '.png'])
%% Plot Saturation
figure('Position', [0,0,800,500])
%%%% Write Your Code Below %%%%
for welli = 1:5
    subplot(2,3,welli)
    plot(S_updated(:,welli),'Color',[.5, .5, .5],'LineWidth',1);
hold on;
plot(S_well_true(:,welli),'r.','MarkerSize',10)
title(wellnames(welli));
ylabel('Saturation(%)') 
xlabel('Year')
end
print('-dpng', '-r100', 'Q2d_update_SWell.png')
indexPng = ['Q2d_update_SWell_' num2str(indexTag)];
saveas(gcf,[indexPng, '.png'])

%% Save Your Updated Permeability for Question 2d(iii)
%%%% Write your code here %%%%



%% Plot Your Well Data for Question 2(iv)
% Color for field data: 'red'
% Color for simualted data without updating: grey [0.5, 0.5, 0.5]
% Color for simulated data with updating: 'cyan'
%%%% Write your code here %%%%
