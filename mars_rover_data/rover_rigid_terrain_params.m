%% Grid Surface Data

% This script creates the parameters necessary to create a Grid Sruface
% from a STL file.

% Copyright 2022-2023 The MathWorks, Inc

%% Get xyz points from STL representing the rigid terrain
Terrain.stl_points = stlread('terrain.STL') ;
Terrain.terrain_points = Terrain.stl_points.Points;

% Remove repeated XY points
[~ ,Terrain.uniqueInd] = unique(Terrain.terrain_points(:,[1 2]),'Rows');
Terrain.terrain_points_new = Terrain.terrain_points(Terrain.uniqueInd,:);
Terrain.terrain_points_new(Terrain.terrain_points_new(:,1)< 40,:) = [];
Terrain.terrain_points_new = [Terrain.terrain_points_new(:,[1 2]) - Terrain.terrain_points_new(1,[1 2]) Terrain.terrain_points_new(:,3)];
Terrain.terrain_points_new(Terrain.terrain_points_new(:,2)< 20,:) = [];
Terrain.terrain_points_new = [Terrain.terrain_points_new(:,[1 2]) - Terrain.terrain_points_new(1,[1 2]) Terrain.terrain_points_new(:,3)];

% seperate them into x, y, and z variables
Terrain.rows = size(Terrain.terrain_points_new,1);
Terrain.x = Terrain.terrain_points_new(:,1); 
Terrain.y = Terrain.terrain_points_new(:,2);
Terrain.z = Terrain.terrain_points_new(:,3);

% Create Grid Vectors & Z height parameters for grid surface block

Terrain.xg = linspace(min(Terrain.x), max(Terrain.x), 100); % x-grid vector
Terrain.yg = linspace(min(Terrain.y), max(Terrain.y), 100); % y-grid vector

% Create an interpolant that fits a surface of the form z = F(x,y)  
Terrain.F = scatteredInterpolant(Terrain.x,Terrain.y,Terrain.z);
Terrain.z_heights = Terrain.F({Terrain.xg,Terrain.yg}); %  Using this syntax to conserve memory when querying a large grid of points.


%% Rocks

[Terrain.sharp_rocks_pts, Terrain.round_rocks_pts, Terrain.ditches_pts] = ...
    createRandomRockLocations(Terrain.xg,Terrain.yg,Terrain.z_heights,{'Sharp Embedded Rocks','Round Embedded Rocks','Ditches'});

Terrain.z_heights = updateTerrainWithDitchesData(Terrain.ditches_pts,Terrain.xg,Terrain.yg,Terrain.z_heights);

% Another grid surface block containing rocks 
Terrain.znew = Terrain.z_heights;
Terrain.znew = updateTerrainWithDitchesData(Terrain.ditches_pts,Terrain.xg,Terrain.yg,Terrain.znew);
Terrain.znew = updateTerrainWithSharpRocksData(Terrain.sharp_rocks_pts,Terrain.xg,Terrain.yg,Terrain.znew);
Terrain.znew = updateTerrainWithSharpRocksData(Terrain.round_rocks_pts,Terrain.xg,Terrain.yg,Terrain.znew);

[Terrain.Xg, Terrain.Yg] = ndgrid(Terrain.xg, Terrain.yg);

Terrain.xg_grid = linspace(min(Terrain.xg),max(Terrain.xg),300);
Terrain.yg_grid = linspace(min(Terrain.yg),max(Terrain.yg),300);

[Terrain.Xq,Terrain.Yq] = ndgrid(Terrain.xg_grid,Terrain.yg_grid);
Terrain.z_heights_grid = interpn(Terrain.Xg,Terrain.Yg,Terrain.z_heights,Terrain.Xq,Terrain.Yq,'cubic');
Terrain.znew_grid = interpn(Terrain.Xg,Terrain.Yg,Terrain.znew,Terrain.Xq,Terrain.Yq,'linear');


