%% Script to plot the end effector path

% Copyright 2022-2023 The MathWorks, Inc
load('roverArmTaskSpaceConfig.mat');

sampleLocation = sm_mars_rover_out.logsout{1}.Values.Data(end,:);
sampleLocation_Approach = [sampleLocation(1) sampleLocation(2) sampleLocation(3)+0.1];
wayPoints_Task= [eeConfig.Targets(1,1:3);...
                 eeConfig.Targets(2,1:3);...
                 sampleLocation_Approach;
                 sampleLocation;
                 eeConfig.Targets(3,1:3);...
                 eeConfig.Targets(4,1:3)];

ee = sm_mars_rover_out.logsout{2}.Values.Data;
cla(mapp.OutputAxes_4);

hold(mapp.OutputAxes_4,'on') ;

plot3(mapp.OutputAxes_4,wayPoints_Task(:,1),wayPoints_Task(:,2),wayPoints_Task(:,3),'ko','LineWidth',0.5,'DisplayName','Waypoints')
axis(mapp.OutputAxes_4,'auto')

title(mapp.OutputAxes_4,'Rover Arm Sample Pick Up Trajectory');

xlabel(mapp.OutputAxes_4,'X (m)');
ylabel(mapp.OutputAxes_4,'Y (m)');
zlabel(mapp.OutputAxes_4,'Z (m)');
view(mapp.OutputAxes_4,-82.2000,9.6)
plot3(mapp.OutputAxes_4,ee(:,1),ee(:,2),ee(:,3),'g--','LineWidth',2,'DisplayName','Trajectory');
plot3(mapp.OutputAxes_4,wayPoints_Task(1,1), wayPoints_Task(1,2), wayPoints_Task(1,3),'bd','LineWidth',2,'DisplayName','Home Position');
plot3(mapp.OutputAxes_4,sampleLocation(1), sampleLocation(2), sampleLocation(3),'md','LineWidth',2,'DisplayName','Grab Sample');
plot3(mapp.OutputAxes_4,wayPoints_Task(6,1), wayPoints_Task(6,2), wayPoints_Task(6,3),'rd','LineWidth',2,'DisplayName','Store Sample');

legend(mapp.OutputAxes_4,'Location','Best');
axis(mapp.OutputAxes_4,'equal')
grid(mapp.OutputAxes_4,'on')
box(mapp.OutputAxes_4,'on')
hold(mapp.OutputAxes_4,'off');