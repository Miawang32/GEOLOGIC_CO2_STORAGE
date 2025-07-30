%% Inspect the geological model
setAxProps = @(ax) set(ax, 'View'              , [-140,20]    , ...
                           'PlotBoxAspectRatio', [2,2,1]      , ...
                           'Projection'        , 'Perspective', ...
                           'Box'               , 'on'         , ...
                           'XLimSpec'          , 'tight'      , ...
                           'YLimSpec'          , 'tight'      , ...
                           'ZLimSpec'          , 'tight'      );

figure('Position', [200,200,800,400])
plotCellData(G, poro,'edgeAlpha',.1); % axis tight;
try
    plotWell(G, W,'height',20);
catch
end
set(gca,'FontSize',12)
mrstColorbar(poro,'South'); % axis equal tight
hold on; 
try
    plot(xw(:,1), xw(:,2),'.r','MarkerSize',18); 
catch
end
hold off; title('Porosity');
setAxProps(gca); drawnow
