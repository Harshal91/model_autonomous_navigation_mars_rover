function plotPlannedPathOnOccupancyMap(ax,rover_path)

% Function to plot planned path on the occupancy map.

% Copyright 2022-2023 The MathWorks, Inc

hold(ax,'on');

plot(ax,rover_path.x,rover_path.y,'--o','LineWidth',1,'MarkerSize',3,'Color',[0 0 1],'DisplayName','Planned Path')

plot(ax,rover_path.sampleLoc(1),rover_path.sampleLoc(2),...
    'mx','LineWidth',3,...
    'MarkerSize',10,'DisplayName','Sample')

hold (ax,'off');

end