function [refpath,solInfo,max_steering_ang] = planRoverRRTStar(map,startLocation,endLocation,minTurningRadius)

% Wrapper function to find a path using RRT star planner.
% Copyright 2022-2023 The MathWorks, Inc

ss = stateSpaceDubins;
ss.MinTurningRadius = minTurningRadius;
ss.StateBounds = [map.XWorldLimits;map.YWorldLimits; [-1*pi pi]];
ss.WeightTheta = 1;

sv = validatorOccupancyMap(ss);
sv.Map = map;
sv.ValidationDistance = 0.01;

rng(100,'twister');

planner = plannerRRTStar(ss,sv);
planner.ContinueAfterGoalReached = true;
% Increase number of iterations to find an improved optimal path.
planner.MaxIterations = 25000;
planner.MaxConnectionDistance = 1;

[refpath,solInfo] = plan(planner,startLocation,endLocation);

% Max steering angle value is derived from minTurningRadius that the rover

% Rover chassis dimesnions
rover_chassis_length = 2;
rover_chassis_width = 1.9621;

% The wheel which is closer to the center of rotation while turing will
% have the max steering angle. Therefore, using the ackerman steering kinematic 
% model (refer to'ModelingAndControlOfAMarsRoverExample.mlx', we can obtain the
% minTurningRadius as below.

max_steering_ang = atan2d((rover_chassis_length*0.5),(minTurningRadius -  rover_chassis_width*0.5)) ;

end