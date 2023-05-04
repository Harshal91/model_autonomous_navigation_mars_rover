function updateExerciseSpecificModelParams(app)

% Copyright 2022-2023 The MathWorks, Inc

switch true

    case evalin('base','Exercise.ex2a_flag == 1')

        model  = 'mars_rover_cam';      
        % Turn on camera pan control for ex-1
        evalin('base','Rover.cam_pan_flag = 1;');       
        
        pan_range = [str2double(app.CameraPanEditField1Ex1.Value) str2double(app.CameraPanEditField2Ex1.Value)];
        evalin('base',['Rover.cam_pan_range = [',num2str(pan_range),'];']);
        evalin('base',['Rover.cam_pitch = ',app.CameraPitchEditField.Value,';']);
        % Set stop time based on camera pan range
        stopTime = abs(pan_range(2)-pan_range(1))/1;
        evalin('base',['Rover.cam_pan_end_time=',num2str(stopTime),';']);
        set_param(model,'StopTime',num2str(stopTime));

    case evalin('base','Exercise.ex2b_flag == 1')

        model  = 'mars_rover_pose';
        evalin('base','Rover.cam_pitch = 10;');
        evalin('base','Rover.start_time=1;');
        evalin('base','Rover.cam_pan_flag=0;');
        evalin('base','Rover.detection_phaseDelay=1e5;');
        evalin('base','Rover.detection_sample_time=1e5;');

        blk = [model '/Mars Rover Plant/Rover Plant Model/Rover Pose Sensing/Rover Six Dof'];
        set_param(blk,'PxDampingCoefficient','0');
        set_param(blk,'PyDampingCoefficient','0');
        set_param(blk,'PzDampingCoefficient','0');

        stopTime = 2000;
        set_param(model,'StopTime',num2str(stopTime));

    case evalin('base','Exercise.ex3_flag == 1')

        model  = 'mars_rover_dl';
        evalin('base','Rover.detection_phaseDelay=0;');
        evalin('base','Rover.detection_sample_time=15;');

        evalin('base','Rover.start_time=1e5;');
        evalin('base','Rover.cam_pan_flag=1;');
        evalin('base','Rover.cam_pitch = 10;');
             
        pan_range = [str2double(app.CameraPanEditField1Ex2.Value) str2double(app.CameraPanEditField2Ex2.Value)];

        evalin('base',['Rover.cam_pan_range = [',num2str(pan_range),'];']); 
        dt = str2double(app.DetectionThresholdEditField.Value);
        % If dt is a very small value like 0 , then we see too many
        % bounding boxes which sporadically causes error on ML Online.
        % So make min dt value to be 0.2 internally eventhoug user can
        % enter 0.
        if dt < 0.2 && dt >= 0
            dt = 0.14;
        end

        evalin('base',['Rover.detectionThreshold = ',num2str(dt),';']);

        stopTime = abs(pan_range(2)-pan_range(1))/0.75;
        set_param(model,'StopTime',num2str(stopTime))
        evalin('base',['Rover.cam_pan_end_time=',num2str(stopTime),';']);

     case evalin('base','Exercise.ex4_flag == 1')

        model  = 'mars_rover_nav';
        evalin('base','Rover.detection_phaseDelay=0;');
        evalin('base','Rover.detection_sample_time=30;');

        evalin('base','Rover.start_time=1;');        
        evalin('base','Rover.cam_pitch = 20;');        
        
end

end