%% Plot plume at end of simulation
setAxProps = @(ax) set(ax, 'View'              , [-140,20]    , ...
                           'PlotBoxAspectRatio', [2,2,1]      , ...
                           'Projection'        , 'Perspective', ...
                           'Box'               , 'on'         , ...
                           'XLimSpec'          , 'tight'      , ...
                           'YLimSpec'          , 'tight'      , ...
                           'ZLimSpec'          , 'tight'      );

sat_end = states{end}.s(:,2);  % co2 saturation at end state

% Plot cells with CO2 saturation more than 0.05
plume_cells = sat_end > 0.05;
% plume_cell2 = sat_end < 0.05;
figure('Position', [200,200,800,400])
clf; plotGrid(G, 'facecolor', 'none', 'EdgeAlpha', 0.1);  % plot outline of simulation grid
% plotGrid(G, plume_cells, 'facecolor', 'red'); % plot cells with CO2 in red
plotCellData(G, sat_end, plume_cells)
% plotCellData(G, sat_end, plume_cell2, 'FaceAlpha', .2, 'EdgeAlpha', 0.0); 
colormap(jet)
mrstColorbar(sat_end,'South'); % axis equal tight
set(gca,'FontSize',12)
setAxProps(gca); drawnow
