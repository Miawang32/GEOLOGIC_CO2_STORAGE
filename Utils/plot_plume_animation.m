figure('Position', [200,200,800,400])
clf; 
plotGrid(G, 'facecolor', 'none', 'EdgeAlpha', 0.1);  % plot outline of simulation grid
colormap(jet)
set(gca,'FontSize',12)
mrstColorbar('South'); % axis equal tight

for t = 1:numel(states)
sat_end = states{t}.s(:,2);  % co2 saturation at end state

% Plot cells with CO2 saturation more than 0.05
plume_cells = sat_end > 0.05;
plotCellData(G, sat_end, plume_cells)
setAxProps(gca); pause(0.1)
end
