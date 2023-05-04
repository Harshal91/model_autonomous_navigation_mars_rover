function Map = createBinaryOccupancyGrid(xg,yg,...
    terrain_points_obs,...
    sharp_rocks_pts,...
    round_rocks_pts,...
    ditches_pts,...
    mapInflationRadius,...
    rocks_select)

% Function to create a binary occupancy grid map.

% Copyright 2022-2023 The MathWorks, Inc

% Create Binary occupacny map
Map = binaryOccupancyMap(max(xg),max(yg),5);


% Set sharp rocks obstacle points
if ismember('Sharp Embedded Rocks',rocks_select)
    Map.setOccupancy(sharp_rocks_pts(:,[1 2]),1);
end
% % Set round embedded rocks obstacle points
% if ismember('Round Embedded Rocks',rocks_select)
%     Map.setOccupancy(round_rocks_pts(:,[1 2]),1);
% end
% Set ditches obstacle points
if ismember('Ditches',rocks_select)
    Map.setOccupancy(ditches_pts(:,[1 2]),1);
end
% Inflate the obstacles to account for Mars Rover's vehicle
% size.
Map.inflate(mapInflationRadius);

% Set terrain inclination obstacles. These are the points above
% the threshold inclination angle

if ~isempty(terrain_points_obs)
    tObs = terrain_points_obs(:,[1 2]);
    obPts = [];
    for i = 1:length(tObs)
        obstacleLocation = tObs(i,:);
        th = 0:pi/10:2*pi;
        xunit = 0.3 * cos(th) + obstacleLocation(1);
        yunit = 0.3* sin(th) + obstacleLocation(2);
        obPts = [obPts; [xunit' yunit']];
    end

    Map.setOccupancy(obPts,1);
end

end