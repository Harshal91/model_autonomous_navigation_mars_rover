function [sharp_rocks_pts, round_rocks_pts, ditches_pts] = ...
    createRandomRockLocations(xg,yg,z_heights,varargin)

% Function to create random rock locations on the terrain.

% Copyright 2022-2023 The MathWorks, Inc

[Xg, Yg] = ndgrid(xg, yg);
terrain_points = [Xg(:) Yg(:) z_heights(:)];

sharp_rocks_pts = [];
round_rocks_pts = [];
ditches_pts = [];

if isempty(varargin)
    rocks_select = {'Sharp Embedded Rocks'};
else
    rocks_select = varargin{1};
end

rng(35153,'twister');

if ismember('Sharp Embedded Rocks',rocks_select)

    for i = 1:3:9
        sharp_rocks_pts = [sharp_rocks_pts ; terrain_points(530+i*1100:40:570+i*1100,:)];
    end

    if ismember('Round Embedded Rocks',rocks_select)

        round_rocks_pts = [sharp_rocks_pts(:,1)+ randi([-4,-2],length(sharp_rocks_pts),1) sharp_rocks_pts(:,2)+randi([-4,-2],length(sharp_rocks_pts),1)  sharp_rocks_pts(:,3)];
        round_rocks_pts = [round_rocks_pts;[sharp_rocks_pts(:,1)+ randi([2,4],length(sharp_rocks_pts),1) sharp_rocks_pts(:,2)+randi([2,4],length(sharp_rocks_pts),1)  sharp_rocks_pts(:,3)]];

    end

    round_rocks_pts([1 2 end],:) =[];
    round_rocks_pts(end-1,:) = [25.4545 23.3755 3.7290];
    round_rocks_pts(2,:) = [18.5859 14.2630 2.0917];
    round_rocks_pts(end,:) = [16.5657 31.2994 3.9330];

    if ismember('Ditches',rocks_select)
        ditches_idx = randi([1 length(xg)*length(yg)],5,1);
        ditches_pts = terrain_points(unique(ditches_idx),:);
    end

end