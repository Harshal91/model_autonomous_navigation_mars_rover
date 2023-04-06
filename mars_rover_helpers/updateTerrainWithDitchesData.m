function  [z_heights,rocks_pc] = updateTerrainWithDitchesData(rocks_sm,xg,yg,z_heights)

% Function to create ditches with randomized depths at provided locations
% on the main terrain. This function first creates a secondary grid
% representing an ellipsoid and then uses points from this secondary grid
% to edit the Z value of the primary terrain grid at the provide xy locations.

% The function takes the original Z heights matrix of the primary
% terrain as the input and updates and outputs the Z values, which represent
% ditches of different depths.

% Copyright 2022-2023 The MathWorks, Inc

[Xm,Ym] = ndgrid(xg,yg); 
rock_pc_idx = 1;
 

for rockIdx = 1:length(rocks_sm)

   %.....Create a grid represnting a ditch at the provided location...........%
    ditch_xyz_pts = createDitch(rocks_sm(rockIdx,:));
    % Seperate  into x, y, and z variables   
    x_d=  ditch_xyz_pts(:,1);
    y_d = ditch_xyz_pts(:,2);
    z_d = ditch_xyz_pts(:,3);
    % Create Grid Vectors & Z height parameters 
    xg_d = linspace(min(x_d), max(x_d),10); % x-grid vector
    yg_d = linspace(min(y_d), max(y_d),10); % y-grid vector
    [X,Y] = ndgrid(xg_d,yg_d);
    % Create an interpolant that fits a surface of the form z = F(x,y)
    F = scatteredInterpolant(x_d,y_d,z_d,'nearest','nearest');
    z_heights_ditch = F({xg_d,yg_d});
    % Get grid data points 
    ditch_grid_p = [X(:), Y(:), z_heights_ditch(:)];

    % ....Update the primrary terrain surface grid with the new Z values based 
    % on the ditch grid..............%

    numP = size(ditch_grid_p,1);
    % Obtain the XY spacing from the grid vectors of the main terrain surface
    % grid.
    xSpacing =abs(xg(2)-xg(1)/99); 
    ySpacing = abs(yg(2)-yg(1)/99);
    last_i = 0;
    last_j = 0;

    % For each of the x,y coordinates of the ditch grid, find the
    % corresponding i and j indices in the Z_heights matrix of the main
    % terrain surface grid. At those indices edit the Z value appropriately. 
    % This will change the main terrain to represent a ditch or a valley

    for looper = 1:numP
        x = ditch_grid_p(looper,1);
        y = ditch_grid_p(looper,2);       

        % Find the I,J indices corresponding to the x,y coordinates of the
        % ditch grid
        i = abs(floor((x/xSpacing)))+1;
        j = abs(floor((y/ySpacing)))+1;
      
        if i == last_i && j ==last_j || i > 100 || j>100
            continue;
        else
            % Edit the Z value in the main terrain grid at that (i,j)

            % Randomized ditch depth relative to the original terrain's Z
            % value.

            a = 2.5;
            b = 0;
            r = (b-a).*rand() + a;
            z_heights(i,j) = z_heights(i,j) - r*0.1*ditch_grid_p(looper,3)/(z_heights(i,j)+ditch_grid_p(looper,3));

            % Get all points representing this ditch. This is utilized by
            % the path planner app to mark the obstacle points.
            rocks_pc(rock_pc_idx,:) = [Xm(i,j) Ym(i,j) z_heights(i,j)];
            rock_pc_idx  = rock_pc_idx +1;
        end

        last_i = i;
        last_j = j;


    end
end
end

function ditch_xyz_pts = createDitch(rocksPts)
% Function to create a ditch based on a provided xyz location.

% Create an ellipsoid shape
[X, Y, Z] = ellipsoid(rocksPts(1),rocksPts(2),rocksPts(3),0.1,0.1,0.3);
% Obtain XYZ points
terrain_points = [X(:), Y(:), Z(:)];
% Remove repeated XY points
[~ ,uniqueInd] = unique(terrain_points(:,[1 2]),'Rows');
ditch_xyz_pts = terrain_points(uniqueInd,:);
end