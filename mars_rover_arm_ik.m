function [out,solutionFlag] =  mars_rover_arm_ik(eePose,eeIgs)
% Uses a persistent KinematicsSolver object to compute the inverse
% kinematics of the rover arm.  Specifically, given the position and orientation 
% of the end effector, it computes the corresponding actuator positions. It
% also uses initial guesses to guide the solver to the desired solution.

% The kinematics solver object is created using a 'mars_rover_arm.slx'
% model which is a replica of the arm being used by the main model 'mars_rover.slx'.

% Copyright 2022-2023 The MathWorks, Inc

persistent ks_mars_rover;
% Note that any structural changes made to the arm in 'mars_rover.slx' wont be
% present in 'mars_rover_arm.slx'. So any such changes to arm must be
% replicated to 'mars_rover_arm.slx' to keep the kinematics of the arm consistent.
mdlpath = ['mars_rover_data',filesep,'mars_rover_arm'];
mdlname = 'mars_rover_arm';
if isempty(ks_mars_rover)
    % Note that this code is only run first time this function is called or
    % if this function is cleared from memory.    
    
    % Create KinematicsSolver object for inverse kinematics.  
    load_system(mdlpath);
    ks_mars_rover = simscape.multibody.KinematicsSolver(mdlname);
    % Add frame variables (end effector position, orientation, with respect to the arm base frame)
    ks_mars_rover.addFrameVariables('Home','T',[mdlname '/Chassis/ArmBase/F'],[mdlname ,'/Rover Arm/EndEff/EndEffector/F']);
    ks_mars_rover.addFrameVariables('Home','R',[mdlname '/Chassis/ArmBase/F'],[mdlname ,'/Rover Arm/EndEff/EndEffector/F']);
    % Add target variables (end effector position and orientation)
    ks_mars_rover.addTargetVariables([ks_mars_rover.frameVariables.ID]);
    % Add initial guess variables (actuator positions)
    rover_arm_jointsIDs = ["j1.Rz.q";"j2.Rz.q";"j3.Rz.q";"j4.Rz.q";"j5.Rz.q";"j6.Rz.q" ];
    ks_mars_rover.addInitialGuessVariables(rover_arm_jointsIDs);
    % Add output variables (actuator positions)
    ks_mars_rover.addOutputVariables(rover_arm_jointsIDs);
    
    close_system(mdlname);   
end
% Solve for multiple end effector targets
for i = 1:size(eePose,1)   
    if i ==4
        [out(i,:),status,~,~] = ks_mars_rover.solve(eePose(i,:),out(i-1,:));
    else
        [out(i,:),status,~,~] = ks_mars_rover.solve(eePose(i,:),eeIgs(i,:));
    end
    if status~=1        
        error(['Solution not found'])        
    end    
end

solutionFlag = status;

end