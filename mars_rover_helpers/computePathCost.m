function d = computePathCost(sm_mars_rover_out,roverPath)

% Function to compute the inclination angles between 2 path xyz points.

% Copyright 2022-2023 The MathWorks, Inc

% timeAtRoverGoal = sm_mars_rover_out.timeAtGoal;

% Only consider indexes from t = 0 to t = when rover stops at goal.

% Actual x and y coordinates of the rover from simulation
xout = sm_mars_rover_out.logsout{5}.Values.Data;
yout = sm_mars_rover_out.logsout{4}.Values.Data;
idx = find(sm_mars_rover_out.tout >= 2);


% Interpolate reference waypoints using the length of the actual xout
refPathx_vec = linspace(min(roverPath.x),max(roverPath.x),length(xout(idx)));
refPathy_vec = interp1(roverPath.x,roverPath.y,refPathx_vec,'linear');

% For computing the error between the actual path vs the reference path, we
% need the time scaled reference x and y values and cant use just the
% reference waypoints.

% Calculate time series from interpolated reference path and based on avg
% linvel of the actual rover.

avg_linvel = mean(sm_mars_rover_out.LinVel(idx));

for i = 1:length(refPathx_vec)-1

   
    temp_t = sqrt((refPathx_vec(i+1)-refPathx_vec(i))^2 + (refPathy_vec(i+1)-refPathy_vec(i))^2)/(avg_linvel) ;  
    
    if i ==1 
         t_exp = 1;
    else
         t_exp(i) = t_exp(i-1) + temp_t;
    end
    
   

end
 t_exp(end+1) = t_exp(end) + temp_t;
 %% Interpolate the reference path at actual time query points 
 x_timeScaled = interp1(t_exp,refPathx_vec,sm_mars_rover_out.tout(idx));
 y_timeScaled = interp1(t_exp,refPathy_vec,sm_mars_rover_out.tout(idx));


% minSize = min(size(xoutUnique),size(youtUnique));
% y_act_at_x_exp = interp1(xoutUnique(1:minSize),youtUnique(1:minSize),x_timeScaled,'linear');

d = (((x_timeScaled - xout(idx)).^2 + ( y_timeScaled - yout(idx)).^2)).^(1/2);


t = tiledlayout(2,1);
nexttile;
hold('on');
plot(x_timeScaled, y_timeScaled,'r--','LineWidth',1,'DisplayName','Waypoints')
plot(roverPath.x,roverPath.y,'o','LineWidth',0.01,'DisplayName','Waypoints')
plot(xout,yout,'g-','LineWidth',2,'DisplayName','ActualPath');
plot(roverPath.sampleLoc(1),roverPath.sampleLoc(2),'bx','MarkerSize',12,'DisplayName','Sample')
% ax1.XColor = 'r';
% ax1.YColor = 'r';
hold('off');

 nexttile;
% %plot(sm_mars_rover_out.tout(idx),);
 plot(xout(idx),d);
d = d(~isnan(d));
% ax2.XAxisLocation = 'top';
% ax2.YAxisLocation = 'right';
% ax2.Color = 'none';
% ax1.Box = 'off';
% ax2.Box = 'off';

legend('Location','Best');
xlabel('X (m)');
ylabel('Y (m)');
movegui('center');

title('Rover Path Comparison in XY plane');


end