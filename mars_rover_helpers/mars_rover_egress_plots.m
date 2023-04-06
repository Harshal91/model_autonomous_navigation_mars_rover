%% Script to plot the roll pitch yaw angles of the rover

% Copyright 2022-2023 The MathWorks, Inc

cla(mapp.OutputAxes_1)
cla(mapp.OutputAxes_2)
cla(mapp.OutputAxes_3)
cla(mapp.OutputAxes_4)    
pause(0.005);

if exist('sm_mars_rover_out_ex1b') ~= 0
   

    xyz_data = sm_mars_rover_out_ex1b.logsout.getElement('RoverTranslation');
    rpy_data = sm_mars_rover_out_ex1b.logsout.getElement('RoverRollPitchYaw');

    hold(mapp.OutputAxes_1,'on') ;
    xlabel(mapp.OutputAxes_1,'Time(s)');
    ylabel(mapp.OutputAxes_1,'Rover X (m)');
    plot(mapp.OutputAxes_1,xyz_data.Values.Time,xyz_data.Values.Data(:,1),'r--','LineWidth',2);
    ylim(mapp.OutputAxes_1,'auto')
    title(mapp.OutputAxes_1,'Rover X position');
    hold(mapp.OutputAxes_1,'off');

    hold(mapp.OutputAxes_2,'on') ;
    xlabel(mapp.OutputAxes_2,'Time(s)');
    ylabel(mapp.OutputAxes_2,'Rover Y (m)');
    plot(mapp.OutputAxes_2,xyz_data.Values.Time,xyz_data.Values.Data(:,2),'g--','LineWidth',2);
    ylim(mapp.OutputAxes_2,'auto')
    title(mapp.OutputAxes_2,'Rover Y position');
    hold(mapp.OutputAxes_2,'off');

    hold(mapp.OutputAxes_3,'on') ;
    xlabel(mapp.OutputAxes_3,'Time(s)');
    ylabel(mapp.OutputAxes_3,'Rover Yaw (deg)');
    plot(mapp.OutputAxes_3,rpy_data.Values.Time,rpy_data.Values.Data(:,3),'b--','LineWidth',2);
    ylim(mapp.OutputAxes_3,'auto')
    title(mapp.OutputAxes_3,'Rover heading angle');
    hold(mapp.OutputAxes_3,'off');

    x_data = sm_mars_rover_out_ex1b.logsout.getElement('RoverPosX');
    y_data = sm_mars_rover_out_ex1b.logsout.getElement('RoverPosY');
    xout = x_data.Values.Data;
    yout = y_data.Values.Data;
    hold(mapp.OutputAxes_4,'on');
    xlabel(mapp.OutputAxes_4,'X(m)');
    ylabel(mapp.OutputAxes_4,'Y(m)');
    x_egress = [str2num(mapp.StartLocationXEditField.Value); str2num(mapp.GoalLocationXEditField.Value)];
    y_egress = [str2num(mapp.StartLocationYEditField.Value); str2num(mapp.GoalLocationYEditField.Value)];
    plot(mapp.OutputAxes_4,x_egress, y_egress,'b--o','LineWidth',0.5,'DisplayName','Egress Path');
    plot(mapp.OutputAxes_4,xout,yout,'-','LineWidth',2.5,'DisplayName','ActualPath','Color',[0.1 0.6745 0.1882]);
    title(mapp.OutputAxes_4,'Rover path comparison in XY plane');

    goal_loc_y_err = abs(y_egress(2)-yout(end));
    text(mapp.OutputAxes_4,(x_egress(1)+x_egress(2))/2,25,['goal loc error = ',num2str(goal_loc_y_err),' m'],'Color',[1 0 0]);

    hold(mapp.OutputAxes_4,'off');

    axis(mapp.OutputAxes_4,'equal');
    legend(mapp.OutputAxes_4,'Location','Best');

end
    
