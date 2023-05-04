function [xg,yg,z_heights,interpolantF] = createTerrainGridSurface(stlfilename)

% Function to create an uneven terrain grid surface from a STL file

% Copyright 2022-2023 The MathWorks, Inc

%% Get xyz points from STL representing the rigid terrain
stl_points = stlread(stlfilename) ;
terrain_points = stl_points.Points;

% Remove repeated XY points
[~,uniqueInd] = unique(terrain_points(:,[1 2]),'Rows');
terrain_points_new = terrain_points(uniqueInd,:);
terrain_points_new(terrain_points_new(:,1)< 40,:) = [];
terrain_points_new = [terrain_points_new(:,[1 2]) - terrain_points_new(1,[1 2]) terrain_points_new(:,3)];
terrain_points_new(terrain_points_new(:,2)< 20,:) = [];
terrain_points_new = [terrain_points_new(:,[1 2]) - terrain_points_new(1,[1 2]) terrain_points_new(:,3)];


% seperate them into x, y, and z variables
x = terrain_points_new(:,1);
y = terrain_points_new(:,2);
z = terrain_points_new(:,3);

% Create Grid Vectors & Z height parameters for grid surface block

xg = linspace(min(x), max(x), 100); % x-grid vector
yg = linspace(min(y), max(y), 100); % y-grid vector

% Create an interpolant that fits a surface of the form z = F(x,y)
interpolantF = scatteredInterpolant(x,y,z);
z_heights = interpolantF({xg,yg}); %  Using this syntax to conserve memory when querying a large grid of points.

end