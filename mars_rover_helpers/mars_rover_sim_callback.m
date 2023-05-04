% Simulation callback script for mars_rover_ex_1b model

% Copyright 2022-2023 The MathWorks, Inc

model = 'mars_rover_dl';
if ~exist('mapp')
    error('Mars Rover Navigation App is not open. Open the app and run the model again.')
elseif ~isvalid(mapp)
    error('Mars Rover Navigation App object is not valid. Open the app and run the model again.')
end

switch true
    case Exercise.ex2a_flag == 1
        mars_rover_camcal_sim_callback
    case Exercise.ex2b_flag == 1
        mars_rover_egress_sim_callback
    case Exercise.ex3_flag == 1
        mars_rover_dl_sim_callback
    case Exercise.ex4_flag == 1
        mars_rover_nav_sim_callback
end