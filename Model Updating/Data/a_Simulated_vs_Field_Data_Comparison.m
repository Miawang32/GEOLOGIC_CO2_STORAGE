clc
clear
close all

%% Load Simulated Data
load('result_all.mat')

%% Load Field Data
load('Field_data.mat')

%% Plot BHP
wellnames = ["I1", "O1", "O2", "O3", "O4"];
figure('Position', [0,0,800,500])
for welli = 1:num_inj
subplot(1,1,welli)
plot(squeeze(BHP_well_3D(:,welli,:)), 'Color', [.5, .5, .5], 'LineWidth', 1);
hold on;
plot(BHP_well_true(:,welli), 'r.', 'MarkerSize', 10)
title(wellnames(welli));
ylabel('BHP (kPa)')
xlabel('Year')
end
print('-dpng', '-r100', 'Q2a_BHPWell.png')

%% Plot Pressure
figure('Position', [0,0,800,500])
for welli = 1:num_inj+num_obs
subplot(2,3,welli)
plot(squeeze(P_well_3D(:,welli,:)), 'Color', [.5, .5, .5], 'LineWidth', 1);
hold on;
plot(P_well_true(:,welli), 'r.', 'MarkerSize', 10)
title(wellnames(welli))
ylabel('Pore Pressure (kPa)')
xlabel('Year')
end
print('-dpng', '-r100', 'Q2a_PWell.png')

%% Plot Saturation
figure('Position', [0,0,800,500])
%%%% Write Your Code Below %%%%
for welli = 1:num_inj+num_obs
    subplot(2,3,welli)
    plot(squeeze(S_well_3D(:,welli,:)),'Color',[.5, .5, .5],'LineWidth',1);
hold on;
plot(S_well_true(:,welli),'r.','MarkerSize',10)
title(wellnames(welli));
ylabel('Saturation(%)') 
xlabel('Year')
end
print('-dpng', '-r100', 'Q2a_SWell.png')

%% Extract first 5 years from all 20 realization
S_hat = S_well_3D(1:5,:,:); %5 year * allwells*allreals
P_hat= P_well_3D(1:5,:,:);
BHP_hat= BHP_well_3D(1:5,:,:);


%% Convert extracted 5 years into vector(1 column)
S_hat_vector = S_hat(:);
P_hat_vector = P_hat(:);
BHP_hat_vector = BHP_hat(:);

%% Convert actual data into one vector (1 column)
S_true_vector = S_well_true(:);
P_true_vector = P_well_true(:);
BHP_true_vector = BHP_well_true(:);


%% Combine first 5 years from 20 realization with 5 actual data
S_all_vector = [S_true_vector;S_hat_vector];
P_all_vector = [P_true_vector;P_hat_vector];
BHP_all_vector = [BHP_true_vector; BHP_hat_vector];

%% Normalize each data in range of 0 to 1
S_all_vector_normalized = normalize(S_all_vector,"range");
P_all_vector_normalized = normalize(P_all_vector,"range");
BHP_all_vector_normalized = normalize(BHP_all_vector,"range");

 %% Reshape back to original dimension the matrix (5*21)actual data+ estimate data
 S_all_normalized = reshape(S_all_vector_normalized,25,21);
 P_all_normalized = reshape(P_all_vector_normalized,25,21);
 BHP_all_normalized = reshape(BHP_all_vector_normalized,5,21);

 %% Combine S,P,BHP vertically into array 
 SPBHP_all_normalized = [S_all_normalized;P_all_normalized;BHP_all_normalized];
 SPBHP_true_normalized = [S_all_normalized(:,1);P_all_normalized(:,1);BHP_all_normalized(:,1)];
 
 %% Calculate RMSE between SPBHP_true_normalized and SPBHP_all_normalized
 %% Normalized to treat all variable equally
 RMSE = rmse(SPBHP_all_normalized(:,2:end),SPBHP_true_normalized);
 %% After run simulation, the lowest 5 series are #16(0.064)< #1(0.0801)< #9(0.0888) <#5(0.099) <#14(0.0994)
 %% Plot BHP for best 5 series
 wellnames = ["I1", "01","02","03","04"];
 figure('Position',[0,0,800,500])
 for welli= 1:num_inj
     subplot(1,1,welli)
     plot(squeeze(BHP_well_3D(1:5,welli,16)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(BHP_well_3D(1:5,welli,1)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(BHP_well_3D(1:5,welli,9)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(BHP_well_3D(1:5,welli,5)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(BHP_well_3D(1:5,welli,14)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(BHP_well_true(:,welli),'r.', 'MarkerSize',10)
     title(wellnames(welli));
     ylabel('BHP(kPa)')
     xlabel('Year')
 end
 print('-dpng','-r100','Q2a_BHPBest5Series.png')

 %% Plot Pressure for best 5 series
 figure('Position',[0,0,800,500])
 for welli = 1:num_inj+num_obs
     subplot(2,3,welli)
     plot(squeeze(P_well_3D(1:5,welli,16)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(P_well_3D(1:5,welli,1)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(P_well_3D(1:5,welli,9)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(P_well_3D(1:5,welli,5)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(P_well_3D(1:5,welli,14)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(P_well_true(:,welli),'r.', 'MarkerSize',10)
     title(wellnames(welli));
     ylabel('Pore Pressure (kPa)')
     xlabel('Year')
 end
 print('-dpng','-r100','Q2a_PBest5Series.png')

 %% Plot Saturation
 figure('Position',[0,0,800,500])
 for welli = 1:num_inj+num_obs
     subplot(2,3,welli)
     plot(squeeze(S_well_3D(1:5,welli,16)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(S_well_3D(1:5,welli,1)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(S_well_3D(1:5,welli,9)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(S_well_3D(1:5,welli,5)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot(squeeze(S_well_3D(1:5,welli,14)),'Color',[.5 .5 .5],'LineWidth',1);
     hold on;
     plot( S_well_true(:,welli),'r.', 'MarkerSize',10)
     title(wellnames(welli));
     ylabel('Saturation')
     xlabel('Year')
 end
 print('-dpng','-r100','Q2a_SBest5Series.png')
 %% 





