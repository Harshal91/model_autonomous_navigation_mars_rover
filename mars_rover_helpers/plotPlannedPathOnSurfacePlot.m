function plotPlannedPathOnSurfacePlot(ax,rover_path)

% Function to plot planned path on the surface plot.

% Copyright 2022-2023 The MathWorks, Inc

hold(ax,'on');
plot3(ax,rover_path.x,rover_path.y,rover_path.z,'--o','MarkerSize',3,'LineWidth',1.5,'Color',[0 0 1],'DisplayName','Planned Path')
plot3(ax,rover_path.sampleLoc(1),rover_path.sampleLoc(2),rover_path.sampleLoc(3),...
    'mx','LineWidth',3,...
    'MarkerSize',10,'DisplayName','Sample')
hold (ax,'off');

end