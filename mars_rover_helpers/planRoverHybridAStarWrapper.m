function [refpath,isPathFound,newMapData,correctedObsLoc]= planRoverHybridAStarWrapper(mapData,startLocation,endLocation,obstacleLocation,initalPath)

% Wrapper function to find an optimal path using Hybird A star planner for
% online planning. In this function we first update the known binary occupancy
% grid with detected rocks and then call the hybrid a start planner.

% Copyright 2022-2023 The MathWorks, Inc

obstacleLocation = obstacleLocation(any(obstacleLocation,2),:);
startLocation = reshape(startLocation,1,3);
endLocation = reshape(endLocation,1,3);
correctedObsLoc = zeros(100,3);
map = binaryOccupancyMap(mapData,'resolution',5);

for i = 1:size(obstacleLocation,1)

    % Correction factor for the depth estimation of the detected rocks. This is
    % computed by increasing the detected rock position by a certain amount
    % on the line joining the current rover XY point and the estimated
    % obstacle XY point.     
    m = (obstacleLocation(i,2)-startLocation(2))/(obstacleLocation(i,1)-startLocation(1));
    d = 1.1;
    if obstacleLocation(i,1) >= startLocation(1)
        x_inflated = obstacleLocation(i,1)+(d/sqrt(m^2+1));
    else
        x_inflated = obstacleLocation(i,1)-(d/sqrt(m^2+1));
    end

    if obstacleLocation(i,2) >= startLocation(2)
        y_inflated  = obstacleLocation(i,2)+(d/sqrt((1/m^2)+1));
    else
        y_inflated  = obstacleLocation(i,2)-(d/sqrt((1/m^2)+1));
    end

    obsInflated = [x_inflated,y_inflated];
    correctedObsLoc(i,:) = [obsInflated 0];
    th = 0:pi/50:2*pi;
    xunit = 2 * cos(th) + obsInflated(1);
    yunit = 2 * sin(th) + obsInflated(2);

    obPts = [xunit' yunit'];

    map.setOccupancy(obPts,1);

    % check if end location is with in this circle
   k = 1;
    while true

        % If the goal location is very close to the newly detected
        % obstacle, move the goal location till it is outside a 2 m radius
        % from the new obstacle.        
        if sqrt((obsInflated(1)-endLocation(1))^2+ (obsInflated(2)-endLocation(2))^2) <= 2 || map.checkOccupancy([endLocation(1) endLocation(2)])            

            endLocation(1) = endLocation(1) + 2;
            k = k+1;
            
        else

            if k ~= 1
                warndlg(['Obstacle detected near the desired goal location. Changing goal to an obstacle free location  [',num2str(endLocation),'].'],'Rock near goal location !');               
            end

            break;
        end

    end

end

if map.checkOccupancy([startLocation(1) startLocation(2)])

    map.setOccupancy([startLocation(1) startLocation(2)],0);
    x = linspace(startLocation(1)-1.5,startLocation(1)+1.5,50);
    y = linspace(startLocation(2)-1.5,startLocation(2)+1.5,50);
    [X,Y] = meshgrid(x,y);

    map.setOccupancy([X(:) Y(:)],0);
end

% if map.checkOccupancy([endLocation(1) endLocation(2)])
% 
%     %warn()
% 
%     while true
%         endLocation(1) = endLocation(1) + 2;
%         if ~map.checkOccupancy([endLocation(1) endLocation(2)])
%             break;
%         end
%     end    
% 
% %     map.setOccupancy([endLocation(1) endLocation(2)],0);
%    
% end

ss = stateSpaceSE2;
ss.WeightTheta = 0;
sv = validatorOccupancyMap(ss);
sv.Map = map;
sv.ValidationDistance = 0.01;
minTurningRadius = 1.5;
motionPrimitiveLength = 1; % Value should be <= 2*pi*minTurningRadius/4;

planner = plannerHybridAStar(sv,'MinTurningRadius',minTurningRadius,'MotionPrimitiveLength',motionPrimitiveLength);
planner.ReverseCost = 10;
planner.DirectionSwitchingCost = 1;

[refpathObj,dir,solInfo] = plan(planner,startLocation,endLocation);

if any(dir == -1)
    for i = 90:90:360      
        newEndOrientation = endLocation(3) + deg2rad(i);
        [refpath,dir,solInfo] = plan(planner,startLocation,[endLocation(1:2) newEndOrientation]);
        if ~any(dir == -1)
            break;
        end
    end
end

refpath = refpathObj.States;
idx = find(dir==-1);
refpath(idx,:) = [];

[xi,yi] = interpPath(refpath(:,1),refpath(:,2),length(initalPath));
refpath  = [xi' yi'];
isPathFound = solInfo.IsPathFound;
newMapData = map.getOccupancy;
end