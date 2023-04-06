%% Script to plot the roll pitch yaw angles of the rover

% Copyright 2022-2023 The MathWorks, Inc

if exist('sm_mars_rover_out') == 0
error('Model was not simulated.')
end

cla(mapp.OutputAxes_2)

rpy_data = sm_mars_rover_out.logsout.getElement('RoverRollPitchYaw');

hold(mapp.OutputAxes_2,'on') ;
title(mapp.OutputAxes_2,'Rover Roll-Pitch-Yaw');

xlabel(mapp.OutputAxes_2,'Time(s)');
ylabel(mapp.OutputAxes_2,'Rover Roll-Pitch-Yaw (deg)');
plot(mapp.OutputAxes_2,rpy_data.Values.Time,rpy_data.Values.Data(:,1),'g--','LineWidth',2,'DisplayName','Roll');
plot(mapp.OutputAxes_2,rpy_data.Values.Time,rpy_data.Values.Data(:,2),'r--','LineWidth',2,'DisplayName','Pitch');
plot(mapp.OutputAxes_2,rpy_data.Values.Time,rpy_data.Values.Data(:,3),'b--','LineWidth',2,'DisplayName','Yaw');
ylim(mapp.OutputAxes_2,'auto')
legend(mapp.OutputAxes_2,'Location','Best');
hold(mapp.OutputAxes_2,'off');