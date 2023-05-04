function plotObstaclesOnOccupancyMap(ax,xg,yg,...
                                 terrain_points_obs,...
                                 sharp_rocks_pts,...
                                 round_rocks_pts,...
                                 loose_rocks_pts, ...
                                 varargin)

% Function to plot obstacle data on the occupancy map.

% Copyright 2022-2023 The MathWorks, Inc

[Xg, Yg] = ndgrid(xg, yg);

if isempty(varargin)
    rocks_select = {'Sharp Embedded Rocks'};
else
    rocks_select = varargin{1};
end

hold(ax,"on");

if ismember('Sharp Embedded Rocks',rocks_select)
plot(ax,sharp_rocks_pts(:,1),sharp_rocks_pts(:,2),'r^','LineWidth',1.25);
end

if ismember('Round Embedded Rocks',rocks_select)
plot(ax,round_rocks_pts(:,1),round_rocks_pts(:,2),'o','LineWidth',1,'Color',[238,130,238]/255*0.8);
end

if ismember('Ditches',rocks_select)
plot(ax,loose_rocks_pts(:,1),loose_rocks_pts(:,2),'*','LineWidth',2,'MarkerSize',2,'Color',[1 1 0]);
end

hold(ax,"off");

end