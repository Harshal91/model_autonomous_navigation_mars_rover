function  [z_heights,rocks_pc] = updateTerrainWithRoundRocksData(rocks_sm,xg,yg,z_heights)

% Function to create round rockes with randomized heights at provided locations
% on the main terrain. This function first creates a secondary grid
% representing an ellipsoid and then uses points from this secondary grid
% to edit the Z value of the primary terrain grid at the provide xy locations.

% The function takes the original Z heights matrix of the primary
% terrain as the input and updates and outputs the Z values, which represent 
% round rockes of differnt heights.

% Copyright 2022-2023 The MathWorks, Inc

[Xm,Ym] = ndgrid(xg,yg); 
rock_pc_idx = 1;
 

for rockIdx = 1:length(rocks_sm)

    %.....Create a grid representing a roundish rock at the provided location...........%

    rocks = roundRocksData(rocks_sm(rockIdx,:));
    % Seperate  into x, y, and z variables      
    x_rocks=  rocks(:,1);
    y_rocks =  rocks(:,2);
    z_rocks =  rocks(:,3);
    % Create Grid Vectors & Z height parameters
    xg_rocks = linspace(min(x_rocks), max(x_rocks),10); % x-grid vector
    yg_rocks = linspace(min(y_rocks), max(y_rocks),10); % y-grid vector
    [X,Y] = ndgrid(xg_rocks,yg_rocks);
    % Create an interpolant that fits a surface of the form z = F(x,y)
    F = scatteredInterpolant(x_rocks,y_rocks,z_rocks,'nearest','nearest');
    z_heights_rocks = F({xg_rocks,yg_rocks});
    % Get grid data points 
    rocks_p = [X(:), Y(:), z_heights_rocks(:)];

    % ....Update the primrary terrain surface grid with the new Z values based 
    % on the round rock grid..............%

    numP = size(rocks_p,1);
    % Obtain the XY spacing from the grid vectors of the main terrain surface
    % grid.
    xSpacing =abs(xg(2)-xg(1)/99); 
    ySpacing = abs(yg(2)-yg(1)/99);
    last_i = 0;
    last_j = 0;

    % For each of the x,y coordinates of the round rock grid, find the
    % corresponding i and j indices in the Z_heights matrix of the main
    % terrain surface grid. At those indices edit the Z value appropriately.
    % This will change the main terrain to represent a round rock.

    for looper = 1:numP
        x = rocks_p(looper,1);
        y = rocks_p(looper,2);
        z = rocks_p(looper,3);

        % Find the I,J indices corresponding to the x,y coordinates of the
        % round rocks grid
        i = abs(floor((x/xSpacing)))+1;
        j = abs(floor((y/ySpacing)))+1;
       
        if i == last_i && j ==last_j || i > 100 || j>100
            continue;
        else
            % Edit the Z value in the main terrain grid at that (i,j)

            % Randomized rock height relative to the original terrain's Z
            % value.
            a = 2;
            b = 0;
            r = (b-a).*rand() + a;
            z_heights(i,j) = z_heights(i,j) + r*0.08*rocks_p(looper,3)/(z_heights(i,j)+rocks_p(looper,3));
            
            % Get all points representing this rock. This is utilized by
            % the path planner app to mark the obstacle points.
            rocks_pc(rock_pc_idx,:) = [Xm(i,j) Ym(i,j) z_heights(i,j)];
            rock_pc_idx  = rock_pc_idx +1;
        end

        last_i = i;
        last_j = j;


    end
end
end

function terrain_points_new = roundRocksData(rocksPts)
% Function to create a round rock based on a provided xyz location.

% Create an ellipsoid shape 
[X, Y, Z] = ellipsoid(rocksPts(1),rocksPts(2),rocksPts(3),0.1,0.1,0.3);

terrain_points = [X(:), Y(:), Z(:)];

% Remove repeated XY points
[~ ,uniqueInd] = unique(terrain_points(:,[1 2]),'Rows');
terrain_points_new = terrain_points(uniqueInd,:);

end