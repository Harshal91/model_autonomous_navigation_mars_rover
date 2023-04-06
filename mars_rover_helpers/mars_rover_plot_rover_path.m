%% Script to plot the rover path

% Copyright 2022-2023 The MathWorks, Inc

if exist('sm_mars_rover_out') == 0
sm_mars_rover_out = sim("sm_mars_rover");
end

x = roverPath.x;
y = roverPath.y;
xout = sm_mars_rover_out.logsout{4}.Values.Data;
yout = sm_mars_rover_out.logsout{3}.Values.Data;

figure;
hold('on');
plot(roverPath.x, roverPath.y,'r--o','LineWidth',1,'DisplayName','Waypoints')
plot(xout,yout,'g-','LineWidth',2,'DisplayName','ActualPath');
plot(sample_position(1),sample_position(2),'bx','MarkerSize',12,'DisplayName','Sample')

legend('Location','Best');
xlabel('X (m)');
ylabel('Y (m)');
movegui('center');

title('Rover Path Comparison in XY plane');
hold off

