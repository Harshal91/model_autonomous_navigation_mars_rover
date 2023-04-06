%% Script to plot the rover speed

% Copyright 2022-2023 The MathWorks, Inc
if exist('sm_mars_rover_out') == 0
error('Model was not simulated.')
end

rover_speed = sm_mars_rover_out.logsout.getElement('RoverSpeed');

hold(mapp.OutputAxes_3,'on') ;
title(mapp.OutputAxes_3,'Rover Desired vs Actual Linear Speed');

xlabel(mapp.OutputAxes_3,'Time(s)');
ylabel(mapp.OutputAxes_3,'Rover Linear Speed (m/s)');
plot(mapp.OutputAxes_3,rover_speed.Values.Time,rover_speed.Values.Data(:,1),'g--','LineWidth',2,'DisplayName','Actual Rover Speed');
plot(mapp.OutputAxes_3,rover_speed.Values.Time,repmat(0.03,length(rover_speed.Values.Time),1),'r--','LineWidth',2,'DisplayName','Desired Rover Speed');
ylim(mapp.OutputAxes_3,'auto')
legend(mapp.OutputAxes_3,'Location','Best');
hold(mapp.OutputAxes_3,'off');