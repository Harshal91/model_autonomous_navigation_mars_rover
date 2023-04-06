function angle = computePathInclinationAngles(rover_path)

% Function to compute the inclination angles between 2 xyz points.

% Copyright 2022-2023 The MathWorks, Inc

for i= 1:length(rover_path.z)-1

    temp = abs(rover_path.z(i+1)-rover_path.z(i))/...
        (sqrt((rover_path.x(i+1)-rover_path.x(i))^2 + (rover_path.y(i+1)-rover_path.y(i))^2));

    angle(i) = atand(temp);

end


end