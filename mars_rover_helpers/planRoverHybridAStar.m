function [refpath,dir,solInfo,endLocation] = planRoverHybridAStar(map,startLocation,endLocation,minTurningRadius)

% Wrapper function to find an optimal path using Hybird A star planner.
% Copyright 2022-2023 The MathWorks, Inc

ss = stateSpaceSE2;
ss.WeightTheta = 0;
sv = validatorOccupancyMap(ss);
sv.Map = map;
sv.ValidationDistance = 0.01;

motionPrimitiveLength =1;%2*pi*minTurningRadius/4; % Value should be <= 2*pi*minTurningRadius/4;

planner = plannerHybridAStar(sv,'MinTurningRadius',minTurningRadius,'MotionPrimitiveLength',motionPrimitiveLength);
planner.ReverseCost = 1e12;
planner.DirectionSwitchingCost = 1e12;

[refpath,dir,solInfo] = plan(planner,startLocation,endLocation);
if any(dir == -1)
    
    for i = 45:45:360
        newEndOrientation = endLocation(3) + i;
        [refpath,dir,solInfo] = plan(planner,startLocation,[endLocation(1:2) newEndOrientation]);
        if ~any(dir == -1)
            endLocation(3) = newEndOrientation;
            %warndlg(['Planner cannot find a forward direction path for the desired goal orientation. Solved for a new goal orientation of ',num2str(newEndOrientation) ,' deg'])    ;
            return;
        end
    end
end



end