%% Script to plot the roll pitch yaw angles of the rover

% Copyright 2022-2023 The MathWorks, Inc

cla(mapp.OutputAxes_1)
cla(mapp.OutputAxes_2)
cla(mapp.OutputAxes_3)
cla(mapp.OutputAxes_4)
pause(0.005);

if exist('sm_mars_rover_out_ex3') ~= 0


    rpy_data = sm_mars_rover_out_ex3.logsout.getElement('RoverRollPitchYaw');
    xyz_data = sm_mars_rover_out_ex3.logsout.getElement('RoverTranslation');
    wheel_speed_data = sm_mars_rover_out_ex3.logsout.getElement('wheel_speeds');
    wheel_trqs_data = sm_mars_rover_out_ex3.logsout.getElement('wheel_trqs');

    hold(mapp.OutputAxes_2,'on') ;
    grid(mapp.OutputAxes_2,'on');
    title(mapp.OutputAxes_2,'Rover Roll-Pitch-Yaw');

    xlabel(mapp.OutputAxes_2,'Time(s)');
    ylabel(mapp.OutputAxes_2,'Rover Roll-Pitch-Yaw (deg)');
    plot(mapp.OutputAxes_2,rpy_data.Values.Time,rpy_data.Values.Data(:,1),'g--','LineWidth',2,'DisplayName','Roll');
    plot(mapp.OutputAxes_2,rpy_data.Values.Time,rpy_data.Values.Data(:,2),'r--','LineWidth',2,'DisplayName','Pitch');
    plot(mapp.OutputAxes_2,rpy_data.Values.Time,rpy_data.Values.Data(:,3),'b--','LineWidth',2,'DisplayName','Yaw');
    ylim(mapp.OutputAxes_2,'auto')
    legend(mapp.OutputAxes_2,'Location','Best');
    hold(mapp.OutputAxes_2,'off');

    hold(mapp.OutputAxes_4,'on') ;
    title(mapp.OutputAxes_4,'Rover Wheel Torque');
    grid(mapp.OutputAxes_4,'on');
    xlabel(mapp.OutputAxes_4,'Time(s)');
    ylabel(mapp.OutputAxes_4,'Torque (N*m)');
    idx = 1000;
    plot(mapp.OutputAxes_4,wheel_trqs_data.Values.Time(idx:end),wheel_trqs_data.Values.Data(idx:end,1),'-','LineWidth',2,'DisplayName','L1');
    plot(mapp.OutputAxes_4,wheel_trqs_data.Values.Time(idx:end),wheel_trqs_data.Values.Data(idx:end,2),'-','LineWidth',2,'DisplayName','L2');
    plot(mapp.OutputAxes_4,wheel_trqs_data.Values.Time(idx:end),wheel_trqs_data.Values.Data(idx:end,3),'-','LineWidth',2,'DisplayName','L3');
    plot(mapp.OutputAxes_4,wheel_trqs_data.Values.Time(idx:end),wheel_trqs_data.Values.Data(idx:end,4),'-','LineWidth',2,'DisplayName','R1');
    plot(mapp.OutputAxes_4,wheel_trqs_data.Values.Time(idx:end),wheel_trqs_data.Values.Data(idx:end,5),'-','LineWidth',2,'DisplayName','R2');
    plot(mapp.OutputAxes_4,wheel_trqs_data.Values.Time(idx:end),wheel_trqs_data.Values.Data(idx:end,6),'-','LineWidth',2,'DisplayName','R3');
    ylim(mapp.OutputAxes_4,'auto')
    legend(mapp.OutputAxes_4,'Location','Best');
    hold(mapp.OutputAxes_4,'off');


    hold(mapp.OutputAxes_3,'on') ;
    title(mapp.OutputAxes_3,'Rover Wheel Speeds');
    grid(mapp.OutputAxes_3,'on');
    xlabel(mapp.OutputAxes_3,'Time(s)');
    ylabel(mapp.OutputAxes_3,'Wheel Speeds (rad/s)');
    idx = 1000;
    plot(mapp.OutputAxes_3,wheel_speed_data.Values.Time(idx:end),abs(wheel_speed_data.Values.Data(idx:end,1)),'-','LineWidth',2,'DisplayName','L1');
    plot(mapp.OutputAxes_3,wheel_speed_data.Values.Time(idx:end),abs(wheel_speed_data.Values.Data(idx:end,2)),'-','LineWidth',2,'DisplayName','L2');
    plot(mapp.OutputAxes_3,wheel_speed_data.Values.Time(idx:end),abs(wheel_speed_data.Values.Data(idx:end,3)),'-','LineWidth',2,'DisplayName','L3');
    plot(mapp.OutputAxes_3,wheel_speed_data.Values.Time(idx:end),abs(wheel_speed_data.Values.Data(idx:end,4)),'-','LineWidth',2,'DisplayName','R1');
    plot(mapp.OutputAxes_3,wheel_speed_data.Values.Time(idx:end),abs(wheel_speed_data.Values.Data(idx:end,5)),'-','LineWidth',2,'DisplayName','R2');
    plot(mapp.OutputAxes_3,wheel_speed_data.Values.Time(idx:end),abs(wheel_speed_data.Values.Data(idx:end,6)),'-','LineWidth',2,'DisplayName','R3');
    ylim(mapp.OutputAxes_3,'auto')
    legend(mapp.OutputAxes_3,'Location','Best');
    hold(mapp.OutputAxes_3,'off');


    grid(mapp.OutputAxes_1,'on');
    mars_rover_plot_rover_path_fn(mapp.OutputAxes_1,sm_mars_rover_out_ex3,roverPath);
   
    axis(mapp.OutputAxes_1,'equal');
   
end