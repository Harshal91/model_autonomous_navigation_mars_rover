%% Script to setup the mars rover navigation app and its corresponding simulink models 

% Copyright 2022-2023 The MathWorks, Inc
flag_explore = false;
flag_dl = false;
flag_nav = false;

addpath('mars_rover_helpers')
addpath('mars_rover_data')
addpath('mars_rover_yolov2_dl')

autoSavedFiles = dir('*.autosave')';

if ~isempty(autoSavedFiles)
    delete(autoSavedFiles.name)    
end

mapp = MarsRoverNavigationApp_Exercises;
d = uiprogressdlg(mapp.MarsRoverNavigationAppUIFigure,'Title','Initializing',...
        'Message','Loading Map...');
d.ShowPercentage = "on";

%% Setup params
d.Value = .15; 
mapData = false(197,200);
mars_rover_params
[goal_loc,roverPath,sample_position,pointCloudPath] = rover_path_select(1);

%% App setup
id = 'Simulink:Engine:NonTunableVarChangedInFastRestart';
warning('off',id)
warning('off','Simulink:Engine:NonTunableVarChangedMaxWarnings');

%% Setup models
d.Value = .25; 
d.Message = 'Loading exercise 1';
pause(0.005)
load_system('simulink')
model_explore = 'mars_rover_explore';

if ~bdIsLoaded(model_explore)
    load_system(model_explore);   
    flag_explore = true;
end

d.Value = .5; 
d.Message = 'Loading exercise 2';
pause(0.005)

model_dl = 'mars_rover_dl';

if ~bdIsLoaded(model_dl)
    load_system(model_dl);
    flag_dl = true;
end

d.Value = .75; 
d.Message = 'Loading exercise 4';
pause(0.005)

model_nav = 'mars_rover_nav';

if ~bdIsLoaded(model_nav)
    load_system(model_nav);
    flag_nav = true;
end

%% Compile models
d.Value = .75; 
d.Message = 'Updating models (this may take a few mins)...';

if flag_dl
    Exercise.ex4_flag = 0;
    Exercise.ex2a_flag = 0;
    Exercise.ex2b_flag = 0;
    Exercise.ex3_flag = 1;
    origText = mapp.SimulateButtonEx2.Text;
    set_param(model_dl,'FastRestart','on');
    st_orig = get_param(model_dl,'StopTime');
    set_param(model_dl,'StopTime','1');   
    sim(model_dl);
    set_param(model_dl,'StopTime',st_orig);
  
    mapp.SimulateButtonEx2.Text = origText;
    mapp.SimulateButtonEx2.Enable = 'on';   
    flag_dl = false;
end

d.Value = .8; 

if flag_nav   
    Exercise.ex4_flag = 1;
    Exercise.ex2a_flag = 0;
    Exercise.ex2b_flag = 0;
    Exercise.ex3_flag = 0;
    origText = mapp.SimulateButtonEx3.Text;      
    st_orig = get_param(model_nav,'StopTime');
    set_param(model_nav,'StopTime','0.3');
    set_param(model_nav,'FastRestart','on'); 
    sim(model_nav);
    set_param(model_nav,'StopTime',st_orig);
    mapp.SimulateButtonEx3.Text = origText;
    mapp.SimulateButtonEx3.Enable = 'off';
    flag_nav = false;
    setMechExplorerVisibility(model_nav,'hide'); 
end

d.Value = .92; 
d.Value = 1; 
d.Message = 'Initialization complete.';
mapp.TabGroup.SelectedTab = mapp.PathPlannerTab;
close all
pause(5)
close(d)


