function state = updateModelData(pt_current,...
                                 cam_ang_current,...
                                 interpolantF)

% Copyright 2022-2023 The MathWorks, Inc

x_init = pt_current(1);
y_init = pt_current(2);

state.rover_path.x = x_init;
state.rover_path.y = y_init;
state.rover_path.z = interpolantF(x_init,y_init);

state.rover_path.t0.pzOffset = interpolantF(x_init,y_init)+0.55;
state.rover_path.t0.yaw = 0;
state.rover_path.t0.pitch = -0.0480*0;
state.rover_path.t0.roll = 0.0147*0;

state.cam_base_angle = cam_ang_current(1);
state.cam_target_angle = cam_ang_current(2);

end