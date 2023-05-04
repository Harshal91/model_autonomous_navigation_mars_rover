% Script to create training data for DL network.

% Copyright 2022-2023 The MathWorks, Inc

%% Set the camera base and tilt angles
mdlname = "mars_rover";
load_system(mdlname);
set_param(mdlname,'StopTime','0');

[xg,yg,z_heights,interpolantF] = createTerrainGridSurface('sm_mars_rover_data/terrain.STL');
set_param(mdlname,'FastRestart','on')

%% Loop setup

x_init = 5:1:75;
y_init = 30:5:50;
target_ang = 10:10:30;
base_ang = linspace(-90,90,10);
k = 1;

for y = y_init

    for x = x_init

        for cam_t = target_ang

            for cam_b = base_ang
                tic
                pt_current = [x,y];
                cam_ang_current = [cam_b,cam_t];

                
                disp(['XY Location ', num2str(pt_current),' cam_angles ',num2str(cam_ang_current)]);

                stateCurrent = updateModelData( pt_current,...
                                                cam_ang_current,...
                                                interpolantF);
                
                rover_path = stateCurrent.rover_path;
                cam_base_ang = stateCurrent.cam_base_angle;
                cam_target_ang = stateCurrent.cam_target_angle;

                
                stateCurrent.sm_mars_rover_out = sim(mdlname);
                

                saveCamImages(stateCurrent);

                state(k) = stateCurrent;
                toc
                k = k+1;
                
            end

        end

    end

end
% 
save('TrainingDataSet.mat','state');