function [x_new,y_new] = interpPath(x,y,num_points)

% Function to resample a set of XY points to a fixed number of points

% Copyright 2022-2023 The MathWorks, Inc

x = reshape(x,1,length(x));
y = reshape(y,1,length(y));

n_div = num_points-1;
d_from_start = cumsum( [0, sqrt((x(2:end)-x(1:end-1)).^2 + (y(2:end)-y(1:end-1)).^2)] );
marker_d = d_from_start(end)/n_div;
marker_locations = marker_d : marker_d : d_from_start(end);  
marker_indices = interp1( d_from_start, 1 : length(d_from_start), marker_locations);
marker_base_pos = floor(marker_indices);
weight_second = marker_indices - marker_base_pos;
mask = marker_base_pos < length(d_from_start);
final_x = x(end); final_y = y(end);
final_marker = any(~mask) & (x(1) ~= final_x | y(1) ~= final_y);
marker_x = [x(1), x(marker_base_pos(mask)) .* (1-weight_second(mask)) + x(marker_base_pos(mask)+1) .* weight_second(mask), final_x(final_marker)];
marker_y = [y(1), y(marker_base_pos(mask)) .* (1-weight_second(mask)) + y(marker_base_pos(mask)+1) .* weight_second(mask), final_y(final_marker)];
x_new = marker_x;
y_new = marker_y;

end