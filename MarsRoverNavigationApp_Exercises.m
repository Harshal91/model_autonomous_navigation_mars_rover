classdef MarsRoverNavigationApp_Exercises < matlab.apps.AppBase
% Copyright 2022-2023 The MathWorks, Inc
    properties(Access = public)
        MarsRoverNavigationAppUIFigure;
        MainGridLayout;
        LeftPanel;
        RightPanel;
        LeftContainer;
        StatusPanel;
        Tree;
        ExerciseGrids;
        Ex0TitleLabel;
        Ex1TitleLabel;
        Ex2TitleLabel;
        Ex3TitleLabel;

        TabGroup;
        PathPlannerTab;

        InputPanel;
        Exercise1Button;
        Exercise1Panel;
        OpenModelButtonEx0;
        Exercise0Panel;        
        PlanaEgressPathButton;
        StartLocationEditFieldLabelEx1;
        GoalLocationEditFieldLabelEx1;
        KalmanFilterCheckBox;
        StartLocationXEditField;
        StartLocationYEditField;
        StartLocationTEditField;
        GoalLocationXEditField;
        GoalLocationYEditField;
        GoalLocationTEditField;
        UpdateGoalLocationViz;

        ProgressBarAxes;

        XLocationLabel;
        YLocationLabel;
        ThetaLocationLabel;

        XLocationLabelEx1;
        YLocationLabelEx1;
        ThetaLocationLabelEx1;

        StartLocationXEditFieldEx3;
        StartLocationYEditFieldEx3;
        StartLocationTEditFieldEx3;
        GoalLocationXEditFieldEx3;
        GoalLocationYEditFieldEx3;
        GoalLocationTEditFieldEx3;

        CameraPitchEditField;
        CameraPanEditField2Ex2;
        CameraPanEditLabelEx2;
        CameraPanEditField1Ex2;

        CameraPanEditField2Ex1;
        CameraPanEditLabelEx1;
        CameraPanEditField1Ex1;

        CameraPanLabelEx1;
        CameraPanLabelEx2;
        DetectionThresholdLabel;
        DetectionThresholdEditField;

        CameraPitchEditFieldLabel;
        Ex1Label1;
        Ex1Label2;
        SimulateButtonEx1;
        SimulateButtonEx1a;

        Exercise2Button;
        Exercise2Panel;
        DNNParametersButton;
        IncludeknownterrainobstaclesCheckBox_2;

        SimulateButtonEx3;
        Exercise3Button;
        Exercise3Panel;
        VisualizeunknownrocksCheckBox;
        SimulateButtonEx2;
        PlanPathButtonEx3;
        PlanPathButton_2;
        TerrainPointsBelowSlopeAngdegSlider;
        TerrainPointsBelowSlopeAngdegSliderLabel;
        IncludeknownterrainobstaclesCheckBox;
        PickGoalpointsinMapCheckBox;
        GoalLocationxyEditField;
        GoalLocationxyEditFieldLabel;
        StartLocationxyEditField;
        StartLocationxyEditFieldLabel;
        BinaryOccupancyAxes;
        TerrainAxes;
        RoverCamsTab;
        GridLayout;
        Panel2;
        LeftNavCamAxes;
        RightNavCamPanel;
        RightNavCamAxes;
        RockDetectionAxes;
        OnlinePathPlansAxes;
        RoverOutputsTab;
        Panel_4;
        OutputAxes_4;
        Panel_3;
        OutputAxes_3;
        Panel_2;
        OutputAxes_2;
        Panel;
        OutputAxes_1;
        statusBar;
        statusBarGrid;
        statusLabel;
        isAppLoaded;
    end

    properties(Access = private)
        OutputsButton
        OutputsPanel
        EnergyCostJEditField
        EnergyCostJEditFieldLabel
        MaxRoverPitchAngledegEditField
        MaxRoverPitchAngledegEditFieldLabel
        TotalPathLengthmEditField
        TotalPathLengthmEditFieldLabel
        EstimatedMaxInclinationdegEditField
        EstimatedMaxInclinationdegEditFieldLabel
        lastXValue
        lastGoalLocationValue
        

        % startupFcn
        map; % Description
        interpolantF;
        terrain_points_obs;
        xg;
        yg;
        z_heights;
        fx;
        fy;
        sharp_rocks_pts;
        round_rocks_pts;
        ditches_pts;
        rover_path =[];
        rocks_select;
        terrainObs_h;
        rocksObs_h;
        terrain3dObs_h;
        rocks3dObs_h;
        map_h;
        dcm_obj ;
        roverSimOut;
        
    end

    methods (Access = public)
         function app = MarsRoverNavigationApp_Exercises()
            buildUI(app);
            app.MarsRoverNavigationAppUIFigure.Visible = 'off';
            registerApp(app, app.MarsRoverNavigationAppUIFigure);
            app.isAppLoaded = false;
            app.RightPanel.Visible = 'off';
            app.SimulateButtonEx1.Enable = 'off';
            app.SimulateButtonEx3.Enable = 'off';
            app.startupFcn();
            pause(8);            
            app.MarsRoverNavigationAppUIFigure.Visible = 'on';
            app.RightPanel.Visible = 'on';
            app.isAppLoaded = true;
        end

        function startupFcn(app)

            warning('off','MATLAB:callback:DeletedSource')
            % re-do
            addpath("mars_rover_helpers");            
            % Remove Data tip interaction from both UI Axes. Since we
            % implement datacursor mode later.
            app.TerrainAxes.Interactions = [rotateInteraction zoomInteraction rulerPanInteraction ];
            app.BinaryOccupancyAxes.Interactions = [rotateInteraction zoomInteraction rulerPanInteraction ];
            app.LeftNavCamAxes.Interactions = [];
            app.RightNavCamAxes.Interactions = [];
            enableLegacyExplorationModes(app.MarsRoverNavigationAppUIFigure)

            axtoolbar(app.OutputAxes_1,{'restoreview'});
            axtoolbar(app.OutputAxes_2,{'restoreview'});
            axtoolbar(app.OutputAxes_3,{'restoreview'});
            axtoolbar(app.OutputAxes_4,{'restoreview'});
            axtoolbar(app.TerrainAxes,{'restoreview'});
            axtoolbar(app.BinaryOccupancyAxes,{'restoreview'});
            axtoolbar(app.OnlinePathPlansAxes,{'restoreview'});
            axtoolbar(app.RightNavCamAxes,{'restoreview'});
            axtoolbar(app.LeftNavCamAxes,{'restoreview'});
           

            % Turn clipping off for surf plot zoom.
            app.TerrainAxes.Clipping = 'off';

            app.rocks_select = {};
            %             app.PickGoalpointsinMapCheckBox.Value = true;
            %             PickGoalpointsinMapCheckBoxValueChanged(app)

            % Expand and obtain checked boxes for rocks
            app.rocks_select= {'Sharp Embedded Rocks';'Round Embedded Rocks';'Ditches'};
            % Random number generator for rocks data
            rng(100,'twister');
            % createTerrainGridSurface
            [app.xg,app.yg,app.z_heights,app.interpolantF] = createTerrainGridSurface('mars_rover_data/terrain.STL');
            % Create and obtain rocks data for each type of classified rock
            [app.sharp_rocks_pts, app.round_rocks_pts, app.ditches_pts] ...
                = createRandomRockLocations(app.xg,app.yg,app.z_heights,app.rocks_select);

            [app.z_heights,app.ditches_pts] = updateTerrainWithDitchesData(app.ditches_pts,app.xg,app.yg,app.z_heights);
            [app.z_heights,app.sharp_rocks_pts] = updateTerrainWithSharpRocksData(app.sharp_rocks_pts,app.xg,app.yg,app.z_heights);
            [app.z_heights,app.round_rocks_pts] = updateTerrainWithSharpRocksData(app.round_rocks_pts,app.xg,app.yg,app.z_heights);

            if app.IncludeknownterrainobstaclesCheckBox.Value
                app.rocks_select = {'Sharp Embedded Rocks', 'Ditches'};
            end

            if app.VisualizeunknownrocksCheckBox.Value
                app.rocks_select = [app.rocks_select {'Round Embedded Rocks'}];
            end



            [Xn,Yn] = ndgrid(app.xg,app.yg);

            app.interpolantF = scatteredInterpolant(Xn(:),Yn(:),app.z_heights(:));
            % Obtain terrain points which are above the allowed terrain
            % inclination angle
            [app.terrain_points_obs, app.fx, app.fy]...
                = computeSteepTerrainPoints(app.xg,app.yg,app.z_heights, 40);

            % Create Binary occupacny map
            Map = createBinaryOccupancyGrid(app.xg,app.yg,...
                app.terrain_points_obs,...
                app.sharp_rocks_pts,...
                app.round_rocks_pts,...
                app.ditches_pts,...
                1.4,...%str2double(app.MapObstaclesInflationRadiusEditField.Value),...
                app.rocks_select);

            % Plot the start location and the goal locations on the occupancy map
            % and the surface plot
            app.map = Map;

            % default values for pan & pitch
            app.CameraPitchEditField.Value = '10';
            app.CameraPanEditField2Ex1.Value = '120';
            app.CameraPanEditField1Ex1.Value  = '-120';

            app.CameraPanEditField2Ex2.Value = '120';
            app.CameraPanEditField1Ex2.Value  = '-120';
            % Default XY Start and end Location
            startLocation = [5 24 0]; % x y
            endLocation = [19.9 17.7 0];

            app.StartLocationXEditFieldEx3.Value = num2str(startLocation(1));
            app.StartLocationYEditFieldEx3.Value = num2str(startLocation(2));
            app.StartLocationTEditFieldEx3.Value = num2str(startLocation(3));

            app.GoalLocationXEditFieldEx3.Value = num2str(endLocation(1));
            app.GoalLocationYEditFieldEx3.Value = num2str(endLocation(2));
            app.GoalLocationTEditFieldEx3.Value = num2str(endLocation(3));

            app.lastGoalLocationValue = endLocation;

            app.DetectionThresholdEditField.Value = num2str(0.55);


            % For Ex 1
            startLocation_ex1 = startLocation;
            endLocation_ex1 = [startLocation(1)+5 startLocation(2) startLocation(3)];

            app.StartLocationXEditField.Value = num2str(startLocation_ex1(1));
            app.StartLocationYEditField.Value = num2str(startLocation_ex1(2));
            app.StartLocationTEditField.Value = num2str(startLocation_ex1(3));

            app.GoalLocationXEditField.Value = num2str(endLocation_ex1(1));
            app.lastXValue = endLocation_ex1(1);
            app.GoalLocationYEditField.Value = num2str(endLocation_ex1(2));
            app.GoalLocationTEditField.Value = num2str(endLocation_ex1(3));
            
            %% only for visualization
            % Obtain Z coordinate for the XY start and end location using
            % the scattered interpolant

            % For Ex -3

            %             startLocation_Z = app.interpolantF(startLocation(1),startLocation(2));
            %             endLocation_Z = app.interpolantF(endLocation(1),endLocation(2));
            %
            %             startLocationXYZ = [startLocation(1:2), startLocation_Z];
            %             endLocationXYZ = [endLocation(1:2), endLocation_Z];

            startLocation_ex1_Z = app.interpolantF(startLocation_ex1(1),startLocation_ex1(2));
            endLocation_ex1_Z = app.interpolantF(endLocation_ex1(1),endLocation_ex1(2));

            startLocation_ex1XYZ = [startLocation_ex1(1:2), startLocation_ex1_Z];
            endLocation_ex1XYZ = [endLocation_ex1(1:2), endLocation_ex1_Z];




            % Plot everything on the surface and occupancy axes.
            surface_ax = app.TerrainAxes;
            map_ax = app.BinaryOccupancyAxes;
            view(surface_ax, -25, 15);

            updateVisualization(surface_ax,map_ax,app.map,...
                app.xg,app.yg,app.z_heights,...
                startLocation_ex1XYZ,...
                str2double(app.StartLocationTEditField.Value),...
                endLocation_ex1XYZ,...
                str2double(app.GoalLocationTEditField.Value),...
                app.terrain_points_obs,...
                app.sharp_rocks_pts,...
                app.round_rocks_pts,...
                app.ditches_pts,...
                app.rocks_select);

            assignin('base','mapp',app);
        end

        % Button pushed function: UpdateVisualizationButton
        function UpdateVisualizationButtonPushed(app, event)

            app.TabGroup.SelectedTab = app.PathPlannerTab;

            if ~strcmp(event.Source.Tag,'MaxSlopeAng') && ~strcmp(event.Source.Tag,'RocksTree') &&...
                    ~strcmp(event.Source.Tag,'Simulate')

                if ~isempty(app.dcm_obj)

                    data = app.dcm_obj.getCursorInfo;
                    if ~isempty(data)
                        if length(data)~=1
                            uialert(app.MarsRoverNavigationAppUIFigure,"Invalid number of goal locations choosen. Only one goal location is supported.",'Invalid number of goal locations')
                        else
                            % startLocationXYZ = [data(end).Position(1:2) app.interpolantF(data(end).Position(1:2))];
                            endLocationXYZ = [data(end).Position(1:2) app.interpolantF(data(end).Position(1:2))];

                            % startLocation = startLocationXYZ(1:2);
                            endLocation = endLocationXYZ(1:2);

                            app.GoalLocationXEditFieldEx3.Value = num2str(endLocation(1));
                            app.GoalLocationYEditFieldEx3.Value = num2str(endLocation(2));

                        end
                    end
                end
            end

            app.terrain_points_obs = computeSteepTerrainPoints(app.xg,app.yg,app.z_heights,app.TerrainPointsBelowSlopeAngdegSlider.Value);
            app.rocks_select = {};

            if app.IncludeknownterrainobstaclesCheckBox.Value
                app.rocks_select = {'Sharp Embedded Rocks', 'Ditches'};
            end

            if app.VisualizeunknownrocksCheckBox.Value
                app.rocks_select = [app.rocks_select {'Round Embedded Rocks'}];
            end

            % Create Binary occupacny map
            Map = createBinaryOccupancyGrid(app.xg,app.yg,...
                app.terrain_points_obs,...
                app.sharp_rocks_pts,...
                app.round_rocks_pts,...
                app.ditches_pts,...
                1.4,...%str2double(app.MapObstaclesInflationRadiusEditField.Value),...
                app.rocks_select);

            app.map = Map;

            surface_ax = app.TerrainAxes;
            map_ax = app.BinaryOccupancyAxes;

            if strcmp(event.Source.Tag,'plan_egress_path') || strcmp(event.Source.Tag,'Ex1_x')

                startLocation = [str2double(app.StartLocationXEditField.Value) str2double(app.StartLocationYEditField.Value)];
                endLocation = [str2double(app.GoalLocationXEditField.Value) str2double(app.GoalLocationYEditField.Value)];

                startLocation_Z = app.interpolantF(startLocation(1),startLocation(2));
                endLocation_Z = app.interpolantF(endLocation(1),endLocation(2));

                startLocationXYZ = [startLocation(1:2), startLocation_Z];
                endLocationXYZ = [endLocation(1:2), endLocation_Z];               

            else

                startLocation = [str2double(app.StartLocationXEditFieldEx3.Value) str2double(app.StartLocationYEditFieldEx3.Value)];
                endLocation = [str2double(app.GoalLocationXEditFieldEx3.Value) str2double(app.GoalLocationYEditFieldEx3.Value)];

                startLocation_Z = app.interpolantF(startLocation(1),startLocation(2));
                endLocation_Z = app.interpolantF(endLocation(1),endLocation(2));

                startLocationXYZ = [startLocation(1:2), startLocation_Z];
                endLocationXYZ = [endLocation(1:2), endLocation_Z];

            end

            f = app.MarsRoverNavigationAppUIFigure;
            set(f, 'pointer', 'watch');
            pause(0.05);

            % Plot everything on the surface and occupancy axes.
            cla(app.TerrainAxes);
            cla(app.BinaryOccupancyAxes);
            isGraphicsLoaded = updateVisualization(surface_ax,map_ax,app.map,...
                app.xg,app.yg,app.z_heights,...
                startLocationXYZ,...
                str2double(app.StartLocationTEditFieldEx3.Value),...
                endLocationXYZ,...
                str2double(app.GoalLocationTEditFieldEx3.Value),...
                app.terrain_points_obs,...
                app.sharp_rocks_pts,...
                app.round_rocks_pts,...
                app.ditches_pts,...
                app.rocks_select);

            if isGraphicsLoaded
                set(f, 'pointer', 'arrow');
            end

            % Plot planned path
            if ~isempty(app.rover_path) && ~strcmp(event.Source.Tag,'path_plan')

                plotPlannedPathOnSurfacePlot(surface_ax,app.rover_path);
                plotPlannedPathOnOccupancyMap(map_ax,app.rover_path);

            end
        end

        % Button pushed function: PlanPathButton
        function PlanPathButtonPushed(app, event)
            
            app.TabGroup.SelectedTab = app.PathPlannerTab;

            UpdateVisualizationButtonPushed(app, event);

            surface_ax = app.TerrainAxes;
            map_ax = app.BinaryOccupancyAxes;

            startLocation = [str2double(app.StartLocationXEditFieldEx3.Value) str2double(app.StartLocationYEditFieldEx3.Value) str2double(app.StartLocationTEditFieldEx3.Value)];
            endLocation = [str2double(app.GoalLocationXEditFieldEx3.Value) str2double(app.GoalLocationYEditFieldEx3.Value) str2double(app.GoalLocationTEditFieldEx3.Value)];

            if any(endLocation ~= app.lastGoalLocationValue)
                app.SimulateButtonEx3.Enable = 'off';
            end

            app.lastGoalLocationValue = endLocation;

            if endLocation(1) > 35 || endLocation(1) < 5 || endLocation(2) > 35 || endLocation(2) < 5
                uialert(app.MarsRoverNavigationAppUIFigure,"Goal location is outside of traversable region. Both x and y values should be greater than 5 meters and less than 35 meters.",'Invalid goal location');
                return;
            end

            if all(endLocation(1:2) == startLocation(1:2))
                uialert(app.MarsRoverNavigationAppUIFigure,"Goal location is same as start location. Select a different goal location",'Invalid goal location');
                return;
            end


            f = uiprogressdlg(app.MarsRoverNavigationAppUIFigure,'Title','Path Planner','Message','Finding path...');
            f.Value = 0.5;
            f.Cancelable = 'on';
            plannerType = 'Hybrid A*';

            switch(plannerType)

                case 'Hybrid A*'
                    try
                        [refpath,dir,solInfo,endLocation] = planRoverHybridAStar(app.map,...
                            startLocation,endLocation,...
                            1.5);

                        if ~solInfo.IsPathFound
                            uialert(app.MarsRoverNavigationAppUIFigure,'Could not find a valid path. Change the desired yaw angle and try again.','Path Planner Error')
                            close(f);
                            return;
                        else
                            if any(dir == -1)
                                warndlg('Planned path has reverse directions. Change the desired pose or planner parameters.')
                            end
                            f.Message = 'Path found';
                            f.Value = 1;
                        end
                        close(f);
                    catch ME
                        uialert(app.MarsRoverNavigationAppUIFigure,ME.message,'Path Planner Error');
                        close(f);
                        return;
                    end

                case 'RRT*'

                    try
                        [refpath,solInfo] = planRoverRRTStar(app.map,...
                            startLocation,endLocation,...
                            app.MinTurningRadiusmEditField.Value);

                        if ~solInfo.IsPathFound
                            delete(f)
                            errordlg('Could not find a valid path. Change the desired pose or planner parameters.')
                            return;
                        else
                            waitbar(1,f,'Path found');

                            delete(f);
                        end

                    catch ME
                        errordlg(ME.message);
                        delete(f)
                        return;
                    end

            end

            assignin('base','map',app.map);

            [x_new,y_new] = interpPath(refpath.States(:,1),refpath.States(:,2),17);
            app.rover_path.x = x_new';
            app.rover_path.y = y_new';
            app.rover_path.z = app.interpolantF(app.rover_path.x,...
                app.rover_path.y);

            end_loc_wrt_WF =...
                [app.rover_path.x(end) ,app.rover_path.y(end) ,...
                app.interpolantF(app.rover_path.x(end),app.rover_path.y(end))]';


            app.rover_path.sampleLoc = end_loc_wrt_WF + ...
                eul2rotm([0 0 endLocation(3)],'XYZ')...
                *[1.9 0 0]';

            app.rover_path.sampleLoc(3) = app.interpolantF(app.rover_path.sampleLoc(1),app.rover_path.sampleLoc(2));
            app.rover_path.t0.pzOffset = app.interpolantF(app.rover_path.x(1),app.rover_path.y(1))+0.55;
            app.rover_path.t0.yaw = deg2rad(str2double(app.StartLocationTEditFieldEx3.Value));
            app.rover_path.t0.pitch = -0.0480;
            app.rover_path.t0.roll = 0.0147;
            app.rover_path.Offset_vis_z= 0.0500;
            app.rover_path.name = 'rover_path';

            plotPlannedPathOnSurfacePlot(surface_ax,app.rover_path);
            plotPlannedPathOnOccupancyMap(map_ax,app.rover_path);

            tmp_roverPath = app.rover_path;
            assignin('base','roverPath',tmp_roverPath);

            tmp_pointCloud = [ app.rover_path.x   app.rover_path.y  app.rover_path.z];
            assignin('base','pointCloudPath',tmp_pointCloud);

            angle = computePathInclinationAngles(app.rover_path);

            app.EstimatedMaxInclinationdegEditField.Value = max(angle);

            app.TotalPathLengthmEditField.Value = refpath.pathLength;

            app.MaxRoverPitchAngledegEditField.Value = 0;
            app.EnergyCostJEditField.Value = 0;

            sharp_rocks = [0 0 -1];
            round_rocks = [0 0 -1];
            ditches = [0 0 -1];

            if ismember('Sharp Embedded Rocks',app.rocks_select)
                sharp_rocks = app.sharp_rocks_pts;
            end

            if ismember('Round Embedded Rocks',app.rocks_select)
                round_rocks = app.round_rocks_pts;
            end

            if ismember('Ditches',app.rocks_select)
                ditches = app.ditches_pts;
            end
            %save(['mars_rover_data',filesep,'rover_path.mat'],'roverPath','sharp_rocks','round_rocks','ditches');



            
%             msgbox('Planned Path saved to mars_rover_data \ rover_path.mat');
%             evalin('base',...
%                 '[goal_loc,roverPath,sample_position,pointCloudPath] = rover_path_select(3);');
            assignin('base','mapData',app.map.getOccupancy);
            app.lastGoalLocationValue = [str2double(app.GoalLocationXEditFieldEx3.Value) str2double(app.GoalLocationYEditFieldEx3.Value) str2double(app.GoalLocationTEditFieldEx3.Value)]; 
            app.SimulateButtonEx3.Enable = 'on';
        end

        % Value changed function: PickGoalpointsinMapCheckBox
        function PickGoalpointsinMapCheckBoxValueChanged(app, event)
            app.TabGroup.SelectedTab = app.PathPlannerTab;
            value = app.PickGoalpointsinMapCheckBox.Value;
            if value
               
                app.dcm_obj = datacursormode(app.MarsRoverNavigationAppUIFigure);
                app.dcm_obj.Enable = 'on';
                app.dcm_obj.DisplayStyle = 'datatip';

                % set(app.TerrainAxes.Toolbar,'Visible','off')
                % set(app.BinaryOccupancyAxes.Toolbar,'Visible','off')
                % set(app.RightNavCamAxes.Toolbar,'Visible','off')
                % set(app.LeftNavCamAxes.Toolbar,'Visible','off')
                % set(app.OnlinePathPlansAxes.Toolbar,'Visible','off')
                % set(app.OutputAxes_1.Toolbar,'Visible','off')
                % set(app.OutputAxes_2.Toolbar,'Visible','off')
                % set(app.OutputAxes_3.Toolbar,'Visible','off')
                % set(app.OutputAxes_4.Toolbar,'Visible','off')
                
            else
               
                app.dcm_obj = datacursormode(app.MarsRoverNavigationAppUIFigure);
                app.dcm_obj.Enable = 'off';
                app.dcm_obj.DisplayStyle = 'datatip';

                % set(app.TerrainAxes.Toolbar,'Visible','off')
                % set(app.BinaryOccupancyAxes.Toolbar,'Visible','off')
                % set(app.RightNavCamAxes.Toolbar,'Visible','off')
                % set(app.LeftNavCamAxes.Toolbar,'Visible','off')
                % set(app.OnlinePathPlansAxes.Toolbar,'Visible','off')
                % set(app.OutputAxes_1.Toolbar,'Visible','off')
                % set(app.OutputAxes_2.Toolbar,'Visible','off')
                % set(app.OutputAxes_3.Toolbar,'Visible','off')
                % set(app.OutputAxes_4.Toolbar,'Visible','off')

            end
        end

        % Button pushed function: PlanPathButton
        function PlanaEgressPathButtonPushed(app, event)           


            % Error handling
            app.TabGroup.SelectedTab = app.PathPlannerTab;
            endLocationX = str2double(app.GoalLocationXEditField.Value);
            
            if endLocationX ~= app.lastXValue
                app.SimulateButtonEx1.Enable = 'off';
            end

            startLocationX = str2double(app.StartLocationXEditField.Value);

            if endLocationX(1) < startLocationX(1)
                uialert(app.MarsRoverNavigationAppUIFigure,"Reverse directions are not supported. Select a goal X value which is greater than start X value.",'Invalid egress path')
                return;
            end
            
            if endLocationX(1) < 7 || endLocationX(1) > 20 
                uialert(app.MarsRoverNavigationAppUIFigure,"Egress path should be, at least 2 meters and at most 15 meters long.",'Invalid egress path');
                return;
            end


            %
            startLocation = [str2double(app.StartLocationXEditField.Value) str2double(app.StartLocationYEditField.Value) str2double(app.StartLocationTEditField.Value)];
            endLocation = [str2double(app.GoalLocationXEditField.Value) str2double(app.GoalLocationYEditField.Value) str2double(app.GoalLocationTEditField.Value)];

            if endLocation(1) < startLocation(1)
                uialert("Reverse directions are not supported. Select a goal X value which is greater than start X value.",'Invalid egress path')
                return;
            end

            if endLocation(1) < 7 || endLocation(1) > 20 
                uialert(app.MarsRoverNavigationAppUIFigure,"Egress path should be, atleast 2 meters and atmost 15 meters long.",'Invalid egress path');
                return;
            end

            if endLocation(1) > 35
                uialert(app.MarsRoverNavigationAppUIFigure,"Goal location is outside of traversable region. Both x and y values should be greater than 5 meters and less than 35 meters.",'Invalid goal location');
                return;
            end

            if startLocation(1) < 5
                uialert(app.MarsRoverNavigationAppUIFigure,"Goal location is outside of traversable region. Both x and y values should be greater than 5 meters and less than 35 meters.",'Invalid goal location');
                return;
            end

            app.rover_path.x = [startLocation(1); endLocation(1)];
            app.rover_path.y = [startLocation(2) ;endLocation(2)];
            app.rover_path.z = app.interpolantF(app.rover_path.x,...
                app.rover_path.y);

            end_loc_wrt_WF =...
                [app.rover_path.x(end) ,app.rover_path.y(end) ,...
                app.interpolantF(app.rover_path.x(end),app.rover_path.y(end))]';


            app.rover_path.sampleLoc = end_loc_wrt_WF + ...
                eul2rotm([0 0 endLocation(3)],'XYZ')...
                *[1.9 0 0]';

            app.rover_path.sampleLoc(3) = app.interpolantF(app.rover_path.sampleLoc(1),app.rover_path.sampleLoc(2));
            app.rover_path.t0.pzOffset = app.interpolantF(app.rover_path.x(1),app.rover_path.y(1))+0.55;
            app.rover_path.t0.yaw = deg2rad(str2double(app.StartLocationTEditFieldEx3.Value));
            app.rover_path.t0.pitch = -0.0480;
            app.rover_path.t0.roll = 0.0147;
            app.rover_path.Offset_vis_z= 0.0500;
            app.rover_path.name = 'rover_path';

            
            tmp_roverPath = app.rover_path;

            assignin('base','rover_path_dl',tmp_roverPath);

            tmp_pointCloud = [ app.rover_path.x   app.rover_path.y  app.rover_path.z];
            assignin('base','point_cloud_path_dl',tmp_pointCloud);

%             save(['mars_rover_data',filesep,'rover_path.mat'],'roverPath');
%             evalin('base',...
%                 '[goal_loc,roverPath,sample_position,pointCloudPath] = rover_path_select(3);');
            UpdateVisualizationButtonPushed(app, event);
            app.SimulateButtonEx1.Enable = 'on';
            app.lastXValue = str2double(app.GoalLocationXEditField.Value);                       

        end

        % Value changed function: IncludeknownterrainobstaclesCheckBoxValueChanged
        function IncludeknownterrainobstaclesCheckBoxValueChanged(app, event)
            UpdateVisualizationButtonPushed(app, event);
        end

        % Value changed function: IncludeknownterrainobstaclesCheckBoxValueChanged
        function VisualizeunknownrocksCheckBoxValueChanged(app, event)
            UpdateVisualizationButtonPushed(app, event);
        end

        % Value changed function: TerrainPointsBelowSlopeAngdegSlider
        function TerrainPointsBelowSlopeAngdegSliderValueChanged(app, event)
            UpdateVisualizationButtonPushed(app, event);

        end

        function Ex1DropDownValueChanged(app,event)


            CamComponents.CameraPitchLabel = app.CameraPitchEditFieldLabel;
            CamComponents.CameraPitch = app.CameraPitchEditField;
            CamComponents.CameraPanLabel = app.CameraPanLabelEx1;
            CamComponents.CameraPanEditLabel = app.CameraPanEditLabelEx1;
            CamComponents.CameraPanEdit1 = app.CameraPanEditField1Ex1;
            CamComponents.CameraPanEdit2 = app.CameraPanEditField2Ex1;

            StateComponents.StartLabel = app.StartLocationEditFieldLabelEx1;
            StateComponents.GoalLabel = app.GoalLocationEditFieldLabelEx1;
            StateComponents.StartX = app.StartLocationXEditField;
            StateComponents.StartY = app.StartLocationYEditField;
            StateComponents.StartT = app.StartLocationTEditField;
            StateComponents.GoalX = app.GoalLocationXEditField;
            StateComponents.GoalY = app.GoalLocationYEditField;
            StateComponents.GoalT = app.GoalLocationTEditField;
            StateComponents.Plan = app.PlanaEgressPathButton;


            if strcmp(app.Ex1DropDown.Value,'Calibrate Linear States')

                turnVisibility(app, CamComponents,'off');
                turnVisibility(app, StateComponents, 'on');

            else
                turnVisibility(app, CamComponents,'on');
                turnVisibility(app, StateComponents, 'off');

            end

        end

        function OpenModelButtonEx0ButtonDown(app,event)
            f = app.MarsRoverNavigationAppUIFigure;
            set(f, 'pointer', 'watch');
            pause(0.05);
            open_system('mars_rover_explore');
            isMdlOpen = get_param('mars_rover_explore','Shown');
            if isMdlOpen
                set(f, 'pointer', 'arrow');
            end            
            app.MarsRoverNavigationAppUIFigure.WindowState = 'minimized';            
        end

        function GoToMainMenu(app,event)                       

            % Hide all exercise grid layouts first
            keys = app.ExerciseGrids.keys();
            for i = 1:length(keys)
                gridLayout = app.ExerciseGrids(keys{i}); % Use parentheses for indexing
                gridLayout.Visible = 'off';
            end
        end

        function SimulateButtonEx1aButtonDown(app,event)
            
            % Exercise flag to know which exercise the user is running.
            evalin('base','Exercise.ex2a_flag=1;');
            evalin('base','Exercise.ex2b_flag=0;');
            evalin('base','Exercise.ex3_flag=0;');
            evalin('base','Exercise.ex4_flag=0;');

            % error handling
            pan_range = [str2double(app.CameraPanEditField1Ex1.Value) str2double(app.CameraPanEditField2Ex1.Value)];

            if str2double(app.CameraPanEditField1Ex1.Value) < -120 || str2double(app.CameraPanEditField1Ex1.Value) > 120
                uialert(app.MarsRoverNavigationAppUIFigure,"Pan angle range should be between -120 to 120 deg",'Invalid Pan Angle Range');
               
                return;
            end

            if str2double(app.CameraPanEditField2Ex1.Value) < -120 || str2double(app.CameraPanEditField2Ex1.Value) > 120
                uialert(app.MarsRoverNavigationAppUIFigure,"Pan angle range should be between -120 to 120 deg",'Invalid Pan Angle Range');
               
                return;
            end
            
            if str2double(app.CameraPanEditField1Ex1.Value) == str2double(app.CameraPanEditField2Ex1.Value) 
                uialert(app.MarsRoverNavigationAppUIFigure,"Start and end pan angle values should not be same",'Invalid Pan Angle Range');
                 
                return;
            end
           
            if str2double(app.CameraPitchEditField.Value) < 10 || str2double(app.CameraPitchEditField.Value) > 30
                uialert(app.MarsRoverNavigationAppUIFigure,"Pitch angle should be between 10 to 30 deg",'Invalid Pitch Angle');               
                return;
            end
           
            model = 'mars_rover_cam';                     
            
            if ~bdIsLoaded(model)
                load_system(model);
            end

            updateExerciseSpecificModelParams(app);

            app.statusBarGrid.Visible = 'on';
            app.statusLabel.Text = 'Compiling';
            pause(0.0005)

            app.enableEx1ComponentsDuringSimulation('off');
            app.enableEx2ComponentsDuringSimulation('off');
            app.enableEx3ComponentsDuringSimulation('off');

            pause(0.0005)
            
            if strcmp(event.Source.Text,'Stop') 

                app.statusLabel.Text = 'Stopping';
                simStatus = get_param(model, 'SimulationStatus');

                if strcmp(simStatus,'running')
                    set_param(model, 'SimulationCommand', 'stop')
                end

            else

                app.OnlinePathPlansAxes.Parent.Parent.Visible = 'off';
                app.RockDetectionAxes.Parent.Parent.Visible = 'off';

                app.SimulateButtonEx1a.Enable = 'off';
                pause(0.0005)

                try
                    out = sim(model);
                    assignin('base','sm_mars_rover_out',out);
                    simStatus = get_param(model, 'SimulationStatus');
                    if strcmp(simStatus,'stopped')
                        app.statusLabel.Text = 'Completed';
                        app.statusBarGrid.Visible = 'off';
                    end
                 catch ME
                     app.enableEx1ComponentsDuringSimulation('on');
                     app.enableEx2ComponentsDuringSimulation('on');
                     app.enableEx3ComponentsDuringSimulation('on');

                     app.statusBarGrid.Visible = 'off';
                     app.SimulateButtonEx1a.Enable = 'on';
                     app.SimulateButtonEx1a.Text = 'Calibrate';
                     % app.SimulateButtonEx1.Enable = 'on';
                     % app.SimulateButtonEx1.Text = 'Calibrate';

                    throw(ME);
                end
            end

            if isvalid(app)

                app.enableEx1ComponentsDuringSimulation('on');
                app.enableEx2ComponentsDuringSimulation('on');
                app.enableEx3ComponentsDuringSimulation('on');

                app.statusBarGrid.Visible = 'off';
                app.SimulateButtonEx1a.Enable = 'on';
                app.SimulateButtonEx1a.Text = 'Calibrate';
                % app.SimulateButtonEx1.Enable = 'on';
                % app.SimulateButtonEx1.Text = 'Calibrate';
            end

        end

        function SimulateButtonEx1ButtonDown(app,event)

            evalin('base','Exercise.ex2a_flag=0;');
            evalin('base','Exercise.ex2b_flag=1;');
            evalin('base','Exercise.ex3_flag=0;');
            evalin('base','Exercise.ex4_flag=0;');       

            model = 'mars_rover_pose';               

            updateExerciseSpecificModelParams(app)

            app.statusBarGrid.Visible = 'on';
            app.statusLabel.Text = 'Compiling';
            pause(0.0005)
            app.RockDetectionAxes.Parent.Parent.Visible ='off';

            app.enableEx1ComponentsDuringSimulation('off');
            app.enableEx2ComponentsDuringSimulation('off');
            app.enableEx3ComponentsDuringSimulation('off');

            if strcmp(event.Source.Text,'Stop')

                app.statusLabel.Text = 'Stopping';
                simStatus = get_param(model, 'SimulationStatus');

                if strcmp(simStatus,'running')                    
                    set_param(model, 'SimulationCommand', 'stop')                    
                end

            else
                
                app.OnlinePathPlansAxes.Parent.Parent.Visible = 'on';               
               
                app.SimulateButtonEx1.Enable = 'off';
                pause(0.0005)

                try
                    out = sim(model);
                    assignin('base','sm_mars_rover_out_ex1b',out);                   
                   
                    simStatus = get_param(model, 'SimulationStatus');

                    if strcmp(simStatus,'stopped')
                        app.statusLabel.Text = 'Completed';
                        app.statusBarGrid.Visible = 'off'; 
                        
                    end

                 catch ME 
                     app.enableEx1ComponentsDuringSimulation('on');
                     app.enableEx2ComponentsDuringSimulation('on');
                     app.enableEx3ComponentsDuringSimulation('on');

                     app.statusBarGrid.Visible = 'off';
                     app.SimulateButtonEx1.Enable = 'on';
                     app.SimulateButtonEx1.Text = 'Calibrate';
                     % app.SimulateButtonEx1a.Enable = 'on';
                     % app.SimulateButtonEx1a.Text = 'Calibrate';
                     throw(ME);
                end
            end

            if isvalid(app)


            app.enableEx1ComponentsDuringSimulation('on');
            app.enableEx2ComponentsDuringSimulation('on');
            app.enableEx3ComponentsDuringSimulation('on');

            app.statusBarGrid.Visible = 'off';
            app.SimulateButtonEx1.Enable = 'on';
            app.SimulateButtonEx1.Text = 'Calibrate';
            % app.SimulateButtonEx1a.Enable = 'on';
            % app.SimulateButtonEx1a.Text = 'Calibrate';
            evalin('base','mars_rover_egress_plots');
            app.TabGroup.SelectedTab = app.RoverOutputsTab;

            end
                                           
        end

        function SimulateButtonEx2ButtonDown(app,event)

            evalin('base','Exercise.ex2a_flag=0;');
            evalin('base','Exercise.ex2b_flag=0;');
            evalin('base','Exercise.ex3_flag=1;');
            evalin('base','Exercise.ex4_flag=0;');
           
            % Error handling 
            pan_range = [str2double(app.CameraPanEditField1Ex2.Value) str2double(app.CameraPanEditField2Ex2.Value)];

             if str2double(app.CameraPanEditField1Ex2.Value) < -120 || str2double(app.CameraPanEditField1Ex2.Value) > 120
                uialert(app.MarsRoverNavigationAppUIFigure,"Pan angle range should be between -120 to 120 deg",'Invalid Pan Angle Range');                
                return;
            end

             if str2double(app.CameraPanEditField2Ex2.Value) < -120 || str2double(app.CameraPanEditField2Ex2.Value) > 120
                uialert(app.MarsRoverNavigationAppUIFigure,"Pan angle range should be between -120 to 120 deg",'Invalid Pan Angle Range');                
                return;
            end

             if str2double(app.CameraPanEditField1Ex2.Value) == str2double(app.CameraPanEditField2Ex2.Value) 
                uialert(app.MarsRoverNavigationAppUIFigure,"Start and End pan angle values should not be same",'Invalid Pan Angle Range');                
                return;
             end
                                   
            dt = str2double(app.DetectionThresholdEditField.Value);

            if dt < 0 || dt > 1
                uialert(app.MarsRoverNavigationAppUIFigure,"Detection threshold should be between 0 to 1",'Invalid Detection Threshold');                
                return;
            end
                   
            model = 'mars_rover_dl';                    
            
            if ~bdIsLoaded(model)
                load_system(model);
            end

            updateExerciseSpecificModelParams(app)

            app.statusBarGrid.Visible = 'on';
            app.statusLabel.Text = 'Compiling';
            pause(0.0005)

            app.enableEx1ComponentsDuringSimulation('off');
            app.enableEx2ComponentsDuringSimulation('off');
            app.enableEx3ComponentsDuringSimulation('off');      

            pause(0.0005)

            if strcmp(event.Source.Text,'Stop')
                app.statusLabel.Text = 'Stopping';
                simStatus = get_param(model, 'SimulationStatus');
                if strcmp(simStatus,'running')                    
                    set_param(model, 'SimulationCommand', 'stop')
                end
            else
                
                app.SimulateButtonEx2.Enable = 'off';
                pause(0.0005)

                try
                    out = sim(model);
                    assignin('base','sm_mars_rover_out',out);
                    simStatus = get_param(model, 'SimulationStatus');
                    if strcmp(simStatus,'stopped')
                        app.statusLabel.Text = 'Completed';
                        app.statusBarGrid.Visible = 'off';
                    end
                catch ME
                    app.enableEx1ComponentsDuringSimulation('on');
                    app.enableEx2ComponentsDuringSimulation('on');
                    app.enableEx3ComponentsDuringSimulation('on');

                    app.statusBarGrid.Visible = 'off';
                    app.SimulateButtonEx2.Enable = 'on';
                    app.SimulateButtonEx2.Text = 'Detect';
                    throw(ME);
                end


            end


            if isvalid(app)


            app.enableEx1ComponentsDuringSimulation('on');
            app.enableEx2ComponentsDuringSimulation('on');
            app.enableEx3ComponentsDuringSimulation('on');

            app.statusBarGrid.Visible = 'off';
            app.SimulateButtonEx2.Enable = 'on';
            app.SimulateButtonEx2.Text = 'Detect';          

            end

        end

        function SimulateButtonEx3ButtonDown(app,event)

            model = 'mars_rover_nav';
            evalin('base','Exercise.ex2a_flag=0;');
            evalin('base','Exercise.ex2b_flag=0;');
            evalin('base','Exercise.ex3_flag=0;');
            evalin('base','Exercise.ex4_flag=1;');
            
            if ~bdIsLoaded(model)
                load_system(model);
            end 

            updateExerciseSpecificModelParams(app)

            if strcmp(event.Source.Text,'Stop')
                app.statusLabel.Text = 'Stopping';
                pause(0.0005)
                simStatus = get_param(model, 'SimulationStatus');
                if strcmp(simStatus,'running')                   
                    set_param(model, 'SimulationCommand', 'stop')
                end
            else

                app.statusBarGrid.Visible = 'on';
                app.statusLabel.Text = 'Compiling';
                pause(0.0005)
               
                app.enableEx1ComponentsDuringSimulation('off');
                app.enableEx2ComponentsDuringSimulation('off');   
                app.enableEx3ComponentsDuringSimulation('off');               
                
                app.SimulateButtonEx3.Enable = 'off';
                pause(0.0005)

                try
                    flag = isMechExplorerVisible(bdroot);
                    if ~flag
                    set_param(model,'FastRestart','off');
                    end
                    out = sim(model);
                    assignin('base','sm_mars_rover_out_ex3',out);
%                     set_param(model, 'SimulationCommand', 'start')
                    simStatus = get_param(model, 'SimulationStatus');
                    if strcmp(simStatus,'stopped')
                        app.statusLabel.Text = 'Completed';
                        app.statusBarGrid.Visible = 'off';
                        
                    end
                catch ME
                    app.enableEx1ComponentsDuringSimulation('on');
                    app.enableEx2ComponentsDuringSimulation('on');
                    app.enableEx3ComponentsDuringSimulation('on');

                    app.statusBarGrid.Visible = 'off';
                    app.SimulateButtonEx3.Enable = 'on';
                    app.SimulateButtonEx3.Text = 'Simulate';
                    throw(ME);
                end

            end


            if isvalid(app)

            app.enableEx1ComponentsDuringSimulation('on');
            app.enableEx2ComponentsDuringSimulation('on');
            app.enableEx3ComponentsDuringSimulation('on');

            app.statusBarGrid.Visible = 'off';
            app.SimulateButtonEx3.Enable = 'on';
            app.SimulateButtonEx3.Text = 'Simulate';
            evalin('base','mars_rover_nav_plots');
            
            end

        end

        function Ex3CollapsedChangedFcn(app,event)

            if ~app.Exercise3Panel.Collapsed
               
                app.OnlinePathPlansAxes.Parent.Parent.Visible = 'on';
                app.RockDetectionAxes.Parent.Parent.Visible = 'on';

                app.Exercise1Panel.Collapsed = true;
                app.Exercise2Panel.Collapsed = true;
                app.Exercise0Panel.Collapsed = true;

            end

        end

        function Ex2CollapsedChangedFcn(app,event)

            if ~app.Exercise2Panel.Collapsed

                app.OnlinePathPlansAxes.Parent.Parent.Visible = 'off';
                app.RockDetectionAxes.Parent.Parent.Visible = 'on';

                app.Exercise1Panel.Collapsed = true;
                app.Exercise3Panel.Collapsed = true;
                app.Exercise0Panel.Collapsed = true;

            end

        end

        function Ex1CollapsedChangedFcn(app,event)

            if ~app.Exercise1Panel.Collapsed             
                
                app.RockDetectionAxes.Parent.Parent.Visible = 'off';
                app.OnlinePathPlansAxes.Parent.Parent.Visible = 'on';
               
                app.Exercise3Panel.Collapsed = true;
                app.Exercise2Panel.Collapsed = true;
                app.Exercise0Panel.Collapsed = true;

            end

        end

         function Ex0CollapsedChangedFcn(app,event)

            if ~app.Exercise0Panel.Collapsed             
                
                app.RockDetectionAxes.Parent.Parent.Visible = 'off';
                app.OnlinePathPlansAxes.Parent.Parent.Visible = 'on';
               
                app.Exercise1Panel.Collapsed = true;
                app.Exercise2Panel.Collapsed = true;
                app.Exercise3Panel.Collapsed = true;

            end

        end

        function GoalLocationXValueChangedFcn(app,event)

            endLocation = str2double(app.GoalLocationXEditField.Value);
            
            if endLocation ~= app.lastXValue
                app.SimulateButtonEx1.Enable = 'off';
            end

            startLocation = str2double(app.StartLocationXEditField.Value);

            if endLocation(1) < startLocation(1)
                uialert(app.MarsRoverNavigationAppUIFigure,"Reverse directions are not supported. Select a goal X value which is greater than start X value.",'Invalid egress path')
                return;
            end
            
            if endLocation(1) < 7 || endLocation(1) > 20 
                uialert(app.MarsRoverNavigationAppUIFigure,"Egress path should be, at least 2 meters and at most 15 meters long.",'Invalid egress path');
                return;
            end

            UpdateVisualizationButtonPushed(app, event);

        end

        function GoalLocationEx3XValueChangedFcn(app,event)

            xLocation = str2double(app.GoalLocationXEditField.Value);
            
            if xLocation(1) >= 35 || xLocation(1) <= 5 
                uialert(app.MarsRoverNavigationAppUIFigure,"Goal location is outside of traversable region. Both x and y values should be greater than 5 meters and less than 35 meters.",'Invalid goal location');
                return;
            end

            if xLocation ~= app.lastGoalLocationValue(1)
                app.SimulateButtonEx3.Enable = 'off';
            end            

        end

        function GoalLocationEx3YValueChangedFcn(app,event)

            yLocation = str2double(app.GoalLocationYEditField.Value);
            
            if yLocation(1) >= 35 || yLocation(1) <= 5 
                uialert(app.MarsRoverNavigationAppUIFigure,"Goal location is outside of traversable region. Both x and y values should be greater than 5 meters and less than 35 meters.",'Invalid goal location');
                return;
            end

            if yLocation ~= app.lastGoalLocationValue(2)
                app.SimulateButtonEx3.Enable = 'off';
            end

        end

        function GoalLocationEx3TValueChangedFcn(app,event)

            tLocation = str2double(app.GoalLocationTEditField.Value);           
           

            if tLocation ~= app.lastGoalLocationValue(3)
                app.SimulateButtonEx3.Enable = 'off';
            end

        end

        function UpdateGoalLocationVizButtonPushed(app,event)

            UpdateVisualizationButtonPushed(app, event);
            
            endLocation = [str2double(app.GoalLocationXEditFieldEx3.Value) str2double(app.GoalLocationYEditFieldEx3.Value) str2double(app.GoalLocationTEditFieldEx3.Value)];

            if any(endLocation ~= app.lastGoalLocationValue)
                app.SimulateButtonEx3.Enable = 'off';
            end


            if endLocation(1) > 35 || endLocation(1) < 5 || endLocation(2) > 35 || endLocation(2) < 5
                uialert(app.MarsRoverNavigationAppUIFigure,"Goal location is outside of traversable region. Both x and y values should be greater than 5 meters and less than 35 meters.",'Invalid goal location');
                return;
            end

        end

        function KalmanFilterValueChangedFcn (app,event)            
            if app.KalmanFilterCheckBox.Value
                assignin('base','useKalmanFilter',true);
            else
                assignin('base','useKalmanFilter',false);
            end

        end

        function CloseRequestFcn(app,event)
            
            d = uiprogressdlg(app.MarsRoverNavigationAppUIFigure,'Message','Closing app...','Title','Close');
            d.Value = 0.5;
                
            models = {'mars_rover_dl',...
                'mars_rover_nav',...
                'mars_rover_explore',...
                'mars_rover_cam',...
                'mars_rover_pose'};
            simStatus = {'','','',''};
            for i = 1:length(models)          
           
                if bdIsLoaded(models{i})                 
                set_param(models{i}, 'SimulationCommand', 'stop') 
                simStatus{i} = get_param(models{i},'SimulationStatus');
                end                                     
            
            end
            pause(5)   

            if any(ismember(simStatus,'running'))
                delete(d)
                uialert(app.MarsRoverNavigationAppUIFigure,...
                    'Make sure all the exercise simulations are stopped before attempting to close the app.','Close');                
                return;
            else

                d.Value = 1;
                delete(d)
                try
                close(app.MarsRoverNavigationAppUIFigure,'force');
                catch
                end
            end

        end
%         function OutputsTabCallback(app,event)
% 
%             if ~app.Exercise1Panel.Collapsed
%                 evalin('base','mars_rover_egress_plots');
%             elseif ~app.Exercise3Panel.Collapsed
%                 evalin('base','mars_rover_nav_plots');
%             end
% 
%         end


    end


    methods (Access = protected)
        function buildUI(app)
            createLayouts(app);
            createUIControl(app);
            createAxes(app);
        end

        function createLayouts(app)
            app.MarsRoverNavigationAppUIFigure = uifigure;
            app.MarsRoverNavigationAppUIFigure.Name = 'Mars Rover Navigation App';
            app.MarsRoverNavigationAppUIFigure.CloseRequestFcn = createCallbackFcn(app, @CloseRequestFcn, true);
            app.MarsRoverNavigationAppUIFigure.Position = [50 200 1302 786];
            app.MarsRoverNavigationAppUIFigure.Tag = 'uifig';
            app.MainGridLayout = uigridlayout(app.MarsRoverNavigationAppUIFigure, [12 3]);
            app.MainGridLayout.RowHeight = {'1x'};
            app.MainGridLayout.ColumnWidth = {460,'1x','1x'}; %{'fit', '1x', '1x'};
            app.MainGridLayout.Scrollable = 'on';
            % app.MainGridLayout.BackgroundColor = 'white';

            app.LeftPanel = uipanel(app.MainGridLayout);
            app.LeftPanel.Layout.Row = [1 11];
            app.LeftPanel.Layout.Column = 1;
            app.LeftPanel.Scrollable = 'on';
            app.LeftPanel.BackgroundColor = 'white';

            app.StatusPanel = uipanel(app.MainGridLayout);
            app.StatusPanel.Layout.Row = 12;
            app.StatusPanel.Layout.Column = 1;
            app.StatusPanel.Scrollable = 'on';
            app.StatusPanel.BackgroundColor = 'white';

            app.RightPanel =  uipanel(app.MainGridLayout);
            app.RightPanel.Layout.Row = [1 12];
            app.RightPanel.Layout.Column = [2 3];
            app.RightPanel.Scrollable = 'on';
            app.RightPanel.BackgroundColor = 'white';
        end

        function createAxes(app)
            tabGL = uigridlayout(app.RightPanel, [1 1]);
            tabGL.BackgroundColor = 'white';
            app.TabGroup = uitabgroup(tabGL);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            app.PathPlannerTab = uitab(app.TabGroup);
            app.PathPlannerTab.Title = 'Path Planner';
            app.PathPlannerTab.BackgroundColor = 'white';
            axesPathPlannerTab(app, app.PathPlannerTab)

            app.RoverCamsTab = uitab(app.TabGroup);
            app.RoverCamsTab.Title = 'Sensors';
            app.RoverCamsTab.BackgroundColor = 'white';
            axesCamera(app, app.RoverCamsTab);

            app.RoverOutputsTab = uitab(app.TabGroup);
            %app.RoverOutputsTab.ButtonDownFcn = createCallbackFcn(app, @OutputsTabCallback, true);
            app.RoverOutputsTab.Title = 'States';
            app.RoverOutputsTab.BackgroundColor = 'white';
            axesStates(app, app.RoverOutputsTab);
        end

        %% local functions - right panel
        function axesPathPlannerTab(app, ppTab)

            axesGL = uigridlayout(ppTab, [2, 1]);
            axesGL.RowHeight = {'1x', '1x'};
            axesGL.ColumnWidth = {'1x'};
            axesGL.BackgroundColor = 'white';
            app.TerrainAxes = uiaxes(axesGL);
            app.TerrainAxes.Layout.Row = 1;
            app.TerrainAxes.Layout.Column = 1;

            app.BinaryOccupancyAxes = uiaxes(axesGL);
            app.BinaryOccupancyAxes.Layout.Row = 2;
            app.BinaryOccupancyAxes.Layout.Column = 1;
        end



        function axesCamera(app, camTab)

            axesGLPanel = uigridlayout(camTab, [2, 2]);
            axesGLPanel.RowHeight = {'1x', '1x'};
            axesGLPanel.ColumnWidth = {'1x', '1x'};
            axesGLPanel.BackgroundColor = 'white';
            axesPanel1 = uipanel(axesGLPanel);
            axesPanel1.Layout.Row = 1;
            axesPanel1.Layout.Column = 1;
            axesPanel1.Title = 'Left Camera';
            axesPanel1.BackgroundColor = 'white';
            axes1GL = uigridlayout(axesPanel1, [1 1]);
            axes1GL.RowHeight = {'1x'};
            axes1GL.ColumnWidth = {'1x'};
            app.LeftNavCamAxes = uiaxes(axes1GL);
            app.LeftNavCamAxes.Layout.Row = 1;
            app.LeftNavCamAxes.Layout.Column = 1;
            app.LeftNavCamAxes.Toolbar.Visible = 'off';

            %             app.RightNavCamAxes = uiaxes(axesGL);
            %             app.RightNavCamAxes.Layout.Row = 1;
            %             app.RightNavCamAxes.Layout.Column = 2;
            %             app.RightNavCamAxes.Title.String = 'Right Camera';

            axesPanel2 = uipanel(axesGLPanel);
            axesPanel2.Layout.Row = 1;
            axesPanel2.Layout.Column = 2;
            axesPanel2.Title = 'Right Camera';
            axesPanel2.BackgroundColor = 'white';
            axes2GL = uigridlayout(axesPanel2, [1 1]);
            axes2GL.RowHeight = {'1x'};
            axes2GL.ColumnWidth = {'1x'};
            app.RightNavCamAxes = uiaxes(axes2GL);
            app.RightNavCamAxes.Layout.Row = 1;
            app.RightNavCamAxes.Layout.Column = 1;
            app.RightNavCamAxes.Toolbar.Visible = 'off';

            %             app.RockDetectionAxes = uiaxes(axesGL);
            %             app.RockDetectionAxes.Layout.Row = 2;
            %             app.RockDetectionAxes.Layout.Column = 1;
            %             app.RockDetectionAxes.Title.String = 'Rock Detection';

            axesPanel3 = uipanel(axesGLPanel);
            axesPanel3.Layout.Row = 2;
            axesPanel3.Layout.Column = 1;
            axesPanel3.Title = 'Rock Detection';
            axesPanel3.BackgroundColor = 'white';
            axes3GL = uigridlayout(axesPanel3, [1 1]);
            axes3GL.RowHeight = {'1x'};
            axes3GL.ColumnWidth = {'1x'};
            app.RockDetectionAxes = uiimage(axes3GL);
            app.RockDetectionAxes.ScaleMethod = 'fill';
            app.RockDetectionAxes.Layout.Row = 1;
            app.RockDetectionAxes.Layout.Column = 1;

            %             app.OnlinePathPlansAxes = uiaxes(axesGL);
            %             app.OnlinePathPlansAxes.Layout.Row = 2;
            %             app.OnlinePathPlansAxes.Layout.Column = 2;
            %             app.OnlinePathPlansAxes.Title.String = 'Obstacle Avoidance';

            axesPanel4 = uipanel(axesGLPanel);
            axesPanel4.Layout.Row = 2;
            axesPanel4.Layout.Column = 2;
            axesPanel4.Title = 'Navigation View';
            axesPanel4.BackgroundColor = 'white';
            axes4GL = uigridlayout(axesPanel4, [1 1]);
            axes4GL.RowHeight = {'1x'};
            axes4GL.ColumnWidth = {'1x'};
            app.OnlinePathPlansAxes = uiaxes(axes4GL);
            app.OnlinePathPlansAxes.Layout.Row = 1;
            app.OnlinePathPlansAxes.Layout.Column = 1;
            app.OnlinePathPlansAxes.Toolbar.Visible = 'off';

        end

        %         function axesCamera(app, camTab)
        %
        %             axesGL = uigridlayout(camTab, [2, 2]);
        %             axesGL.RowHeight = {'1x', '1x'};
        %             axesGL.ColumnWidth = {'1x', '1x'};
        %             axesGL.BackgroundColor = 'white';
        %             app.LeftNavCamAxes = uiaxes(axesGL);
        %             app.LeftNavCamAxes.Layout.Row = 1;
        %             app.LeftNavCamAxes.Layout.Column = 1;
        %             app.LeftNavCamAxes.Title.String  = 'Left Camera';
        %
        %             app.RightNavCamAxes = uiaxes(axesGL);
        %             app.RightNavCamAxes.Layout.Row = 1;
        %             app.RightNavCamAxes.Layout.Column = 2;
        %             app.RightNavCamAxes.Title.String = 'Right Camera';
        %
        %             app.RockDetectionAxes = uiaxes(axesGL);
        %             app.RockDetectionAxes.Layout.Row = 2;
        %             app.RockDetectionAxes.Layout.Column = 1;
        %             app.RockDetectionAxes.Title.String = 'Rock Detection';
        %
        %             app.OnlinePathPlansAxes = uiaxes(axesGL);
        %             app.OnlinePathPlansAxes.Layout.Row = 2;
        %             app.OnlinePathPlansAxes.Layout.Column = 2;
        %             app.OnlinePathPlansAxes.Title.String = 'Obstacle Avoidance';
        %
        %         end

        function axesStates(app, statesTab)

            axesGL = uigridlayout(statesTab, [2, 2]);
            axesGL.RowHeight = {'1x', '1x'};
            axesGL.ColumnWidth = {'1x', '1x'};
            axesGL.BackgroundColor = 'white';
            app.OutputAxes_1 = uiaxes(axesGL);
            app.OutputAxes_1.Layout.Row = 1;
            app.OutputAxes_1.Layout.Column = 1;
            app.OutputAxes_1.Title.String = 'Time vs X Position in meters';

            app.OutputAxes_2 = uiaxes(axesGL);
            app.OutputAxes_2.Layout.Row = 1;
            app.OutputAxes_2.Layout.Column = 2;
            app.OutputAxes_2.Title.String = 'Time vs Y Position in meters';

            app.OutputAxes_3 = uiaxes(axesGL);
            app.OutputAxes_3.Layout.Row = 2;
            app.OutputAxes_3.Layout.Column = 1;
            app.OutputAxes_3.Title.String = 'Time vs Yaw Angle in deg';

            app.OutputAxes_4 = uiaxes(axesGL);
            app.OutputAxes_4.Layout.Row = 2;
            app.OutputAxes_4.Layout.Column = 2;
            app.OutputAxes_4.Title.String = '2D Path Viewer';

        end

        function createUIControl(app)
            app.LeftContainer = uigridlayout(app.LeftPanel, [1 1]);
            app.LeftContainer.RowHeight = {"1x"};
            app.LeftContainer.ColumnWidth = {"1x"};
            app.LeftContainer.BackgroundColor = 'white';

            % Create a uitree
            app.Tree = uitree(app.LeftContainer);
            app.Tree.Layout.Row = 1;
            app.Tree.Layout.Column = 1;
            app.Tree.ClickedFcn = @app.onTreeSelectionChanged;


            % Add multiple root nodes to the uitree
            ex0Node = uitreenode(app.Tree, 'Text', 'Exercise - 1: Explore Rover Model');
            ex1Node = uitreenode(app.Tree, 'Text', 'Exercise - 2: Calibration');
            ex2Node = uitreenode(app.Tree, 'Text', 'Exercise - 3: Object Detection');
            ex3Node = uitreenode(app.Tree, 'Text', 'Exercise - 4: Navigation');

            % Expand the root node
            %rootNode.expand();

            % Create grid layouts for each exercise but keep them hidden initially
            app.ExerciseGrids = containers.Map();
            
            pnlGL0 = uigridlayout(app.LeftPanel, [1 3]);
            pnlGL0.RowHeight = {"fit"};
            pnlGL0.ColumnWidth = {"fit"};
            pnlGL0.BackgroundColor = '#f0f0f0';
            pnlGL0.Visible = 'off';
            app.ExerciseGrids('Exercise - 1: Explore Rover Model') = pnlGL0;
            createEx0Components(app, pnlGL0);
            
            pnlGL1 = uigridlayout(app.LeftPanel, [12 3]);
            pnlGL1.RowHeight = {"fit", "fit", "fit","fit","fit","fit","fit","fit","fit","fit","fit","fit"};
            pnlGL1.ColumnWidth = {"fit"};
            pnlGL1.BackgroundColor ='#f0f0f0';
            pnlGL1.Visible = 'off';
            app.ExerciseGrids('Exercise - 2: Calibration') = pnlGL1;
            createEx1Components(app, pnlGL1);
            
            pnlGL2 = uigridlayout(app.LeftPanel, [5 4]);
            pnlGL2.RowHeight = {"fit", "fit", "fit","fit","fit"};
            pnlGL2.ColumnWidth = {"fit"};
            pnlGL2.BackgroundColor ='#f0f0f0';
            pnlGL2.Visible = 'off';
            app.ExerciseGrids('Exercise - 3: Object Detection') = pnlGL2;
            createEx2Components(app, pnlGL2);
          
            pnlGL3 = uigridlayout(app.LeftPanel, [10 3]);
            pnlGL3.RowHeight = {"fit", "fit", "fit", "fit", ...
                "fit", "fit", "fit", "fit","fit","fit"};
            pnlGL3.ColumnWidth = {"fit"};
            pnlGL3.BackgroundColor = '#f0f0f0';
            pnlGL3.Visible = 'off';
            app.ExerciseGrids('Exercise - 4: Navigation') = pnlGL3;
            createEx3Components(app, pnlGL3);

            app.statusBarGrid = uigridlayout(app.StatusPanel,[1 4]);
            app.statusBarGrid.RowHeight = {'fit'};
            app.statusBarGrid.ColumnWidth = {'1x'};
            app.statusBarGrid.BackgroundColor = 'white';
            app.statusBarGrid.Visible = 'off';

            app.statusLabel = uilabel(app.statusBarGrid);
            app.statusLabel.Layout.Row = 1;
            app.statusLabel.Layout.Column = 1;
            app.statusLabel.Text = 'Running';
            app.statusLabel.FontWeight = 'Bold';
            app.statusLabel.HorizontalAlignment = 'center';

            app.statusBar = uiimage(app.statusBarGrid);
            app.statusBar.Layout.Row = 1;
            app.statusBar.Layout.Column = [2 4];
            app.statusBar.ImageSource = 'progressBar.gif';

        end

        function onTreeSelectionChanged(app, src, event)
            % Get the selected node
            selectedNode = event.InteractionInformation.Node;

            if isempty(selectedNode)
                return;
            end

            % Collapse all nodes except the selected one
            allNodes = src.Children;  % Assuming src is the uitree
            for i = 1:length(allNodes)
                if allNodes(i) ~= selectedNode
                    allNodes(i).collapse;
                end
            end

            % Expand the selected node
            selectedNode.expand;

            % Hide all exercise grid layouts first
            keys = app.ExerciseGrids.keys();
            for i = 1:length(keys)
                gridLayout = app.ExerciseGrids(keys{i}); % Use parentheses for indexing
                gridLayout.Visible = 'off';
            end

            % Show the grid layout corresponding to the selected exercise
            if isKey(app.ExerciseGrids, selectedNode.Text)
                
                selectedExercise = find(ismember(app.ExerciseGrids.keys,selectedNode.Text));

                switch selectedExercise

                    case 1

                        app.RockDetectionAxes.Parent.Parent.Visible = 'off';
                        app.OnlinePathPlansAxes.Parent.Parent.Visible = 'on';

                    case 2
                        app.RockDetectionAxes.Parent.Parent.Visible = 'off';
                        app.OnlinePathPlansAxes.Parent.Parent.Visible = 'on';

                    case 3
                        app.RockDetectionAxes.Parent.Parent.Visible = 'on';
                        app.OnlinePathPlansAxes.Parent.Parent.Visible = 'off';

                    case 4
                        app.RockDetectionAxes.Parent.Parent.Visible = 'on';
                        app.OnlinePathPlansAxes.Parent.Parent.Visible = 'on';

                    otherwise
                        error('Invalid exercise selected')

                end

                gridLayout = app.ExerciseGrids(selectedNode.Text); % Use parentheses for indexing
                gridLayout.Visible = 'on';
            end
        end

        function createEx0Components(app,gridlayout)

            swapGL = uigridlayout(gridlayout, [10 5]);
            swapGL.Layout.Row = 1;
            swapGL.Layout.Column = 2;
            swapGL.RowHeight = {'fit'};
            swapGL.ColumnWidth = {50,50,50,50,50};
            swapGL.BackgroundColor = 'white';

            app.Ex0TitleLabel = uilabel(swapGL);
            app.Ex0TitleLabel.Layout.Row = 1;
            app.Ex0TitleLabel.Layout.Column = [1 5];
            app.Ex0TitleLabel.Text = 'Exercise - 1: Explore Rover Model';
            app.Ex0TitleLabel.FontWeight = 'Bold';

             % Create SimulateButtonEx1
            app.OpenModelButtonEx0 = uibutton(swapGL, 'push');
            app.OpenModelButtonEx0.ButtonPushedFcn = createCallbackFcn(app, @OpenModelButtonEx0ButtonDown, true);
            app.OpenModelButtonEx0.Tag = 'simulate';
            app.OpenModelButtonEx0.FontWeight = 'bold';
            app.OpenModelButtonEx0.Layout.Row = [3 5];
            app.OpenModelButtonEx0.Layout.Column = [2 5];
            app.OpenModelButtonEx0.Text = 'Open Rover Model';

            % Create go to Exercise Menu button
            app.OpenModelButtonEx0 = uibutton(swapGL, 'push');
            app.OpenModelButtonEx0.ButtonPushedFcn = createCallbackFcn(app, @GoToMainMenu, true);
            app.OpenModelButtonEx0.Tag = 'back';
            %app.OpenModelButtonEx0.FontWeight = 'bold';
            app.OpenModelButtonEx0.Layout.Row = [7 9];
            app.OpenModelButtonEx0.Layout.Column = [1 2];
            app.OpenModelButtonEx0.Text = [char(10229) ' Exercise Menu'];

        end

        function createEx1Components(app, gridlayout)

            % Create Ex1DropDown
            %             app.Ex1DropDown = uidropdown(gridlayout);
            %             app.Ex1DropDown.Items = {'Calibrate Sensors', 'Calibrate Linear States'};
            %             app.Ex1DropDown.ValueChangedFcn = createCallbackFcn(app, @Ex1DropDownValueChanged, true);
            %             app.Ex1DropDown.Layout.Row = 1;
            %             app.Ex1DropDown.Layout.Column = 1;
            %             app.Ex1DropDown.Value = 'Calibrate Sensors';

            app.Ex1TitleLabel = uilabel(gridlayout);
            app.Ex1TitleLabel.Layout.Row = 1;
            app.Ex1TitleLabel.Layout.Column = [1 3];
            app.Ex1TitleLabel.Text = 'Exercise - 2: Calibrate';
            app.Ex1TitleLabel.FontWeight = 'Bold';

            app.Ex1Label1 = uilabel(gridlayout);
            app.Ex1Label1.Layout.Row = 2;
            app.Ex1Label1.Layout.Column = 1;
            app.Ex1Label1.Text = 'Calibrate Sensors';
            app.Ex1Label1.FontWeight = 'Bold';

            swapGL = uigridlayout(gridlayout, [3 4]);
            swapGL.Layout.Row = 2;
            swapGL.Layout.Column = [1 3];
            swapGL.RowHeight = {'fit', 'fit', 'fit'};
            swapGL.ColumnWidth = {'fit', 50, 50, 50};
            swapGL.BackgroundColor = 'white';

            % Create CameraPitchEditFieldLabel
            app.CameraPitchEditFieldLabel = uilabel(swapGL);
            app.CameraPitchEditFieldLabel.Layout.Row = 1;
            app.CameraPitchEditFieldLabel.Layout.Column = 1;
            app.CameraPitchEditFieldLabel.Text = 'Camera Pitch (10 to 30 deg)';

            % Create CameraPitchEditField
            app.CameraPitchEditField = uieditfield(swapGL, 'text');
       %     app.CameraPitchEditField.ValueChangedFcn = createCallbackFcn(app, @CameraEx1ValueChanged, true);
            app.CameraPitchEditField.Editable = 'on';
            app.CameraPitchEditField.Layout.Row = 1;
            app.CameraPitchEditField.Layout.Column = 2;

            % Create CameraPanLabel
            app.CameraPanLabelEx1 = uilabel(swapGL);
            app.CameraPanLabelEx1.Layout.Row = 2;
            app.CameraPanLabelEx1.Layout.Column = 1;
            app.CameraPanLabelEx1.Text = 'Camera Pan (-120 to 120 deg)';

            % Create CameraPanEditField1
            app.CameraPanEditField1Ex1 = uieditfield(swapGL, 'text');
        %    app.CameraPanEditField1Ex1.ValueChangedFcn = createCallbackFcn(app, @CameraEx1ValueChanged, true);
            app.CameraPanEditField1Ex1.Layout.Row = 2;
            app.CameraPanEditField1Ex1.Layout.Column = 2;

            % Create CameraPanEditLabel2
            app.CameraPanEditLabelEx1 = uilabel(swapGL);
            app.CameraPanEditLabelEx1.Layout.Row = 2;
            app.CameraPanEditLabelEx1.Layout.Column = 3;
            app.CameraPanEditLabelEx1.Text = 'to';
            app.CameraPanEditLabelEx1.HorizontalAlignment = 'center';

            % Create CameraPanEditField2
            app.CameraPanEditField2Ex1 = uieditfield(swapGL, 'text');
         %   app.CameraPanEditField2Ex1.ValueChangedFcn = createCallbackFcn(app, @CameraEx1ValueChanged2, true);
            app.CameraPanEditField2Ex1.Layout.Row = 2;
            app.CameraPanEditField2Ex1.Layout.Column = 4;


            % Create PlanaEgressPathButton
            buttonLayout = uigridlayout(gridlayout, [1 4]);
            buttonLayout.RowHeight = {'fit'};
            buttonLayout.ColumnWidth = {'fit', '1x', '1x', 'fit'};
            buttonLayout.Layout.Row = 4;
            buttonLayout.Layout.Column = [1 3];
            buttonLayout.BackgroundColor = 'white';
            % Create SimulateButtonEx1
            app.SimulateButtonEx1a = uibutton(buttonLayout, 'push');
            app.SimulateButtonEx1a.ButtonPushedFcn = createCallbackFcn(app, @SimulateButtonEx1aButtonDown, true);
            app.SimulateButtonEx1a.Tag = 'simulate';
            app.SimulateButtonEx1a.FontWeight = 'bold';
            app.SimulateButtonEx1a.Layout.Row = 1;
            app.SimulateButtonEx1a.Layout.Column = 4;
            app.SimulateButtonEx1a.Text = 'Calibrate';


            app.Ex1Label2 = uilabel(gridlayout);
            app.Ex1Label2.Layout.Row = 5;
            app.Ex1Label2.Layout.Column = 1;
            app.Ex1Label2.Text = 'Calibrate Rover Position';
            app.Ex1Label2.FontWeight = 'Bold';

            swapGL_1 = uigridlayout(gridlayout, [4 4]);
            swapGL_1.Layout.Row = 6;
            swapGL_1.Layout.Column = [1 3];
            swapGL_1.RowHeight = {'fit', 'fit', 'fit'};
            swapGL_1.ColumnWidth = {'fit', 50, 50, 50};
            swapGL_1.BackgroundColor = 'white';


            app.XLocationLabelEx1 = uilabel(swapGL_1);
            app.XLocationLabelEx1.Enable = 'off';
            app.XLocationLabelEx1.Layout.Row = 1;
            app.XLocationLabelEx1.Layout.Column = 2;
            app.XLocationLabelEx1.Text = 'x(m)';

            app.YLocationLabelEx1 = uilabel(swapGL_1);
            app.YLocationLabelEx1.Enable = 'off';
            app.YLocationLabelEx1.Layout.Row = 1;
            app.YLocationLabelEx1.Layout.Column = 3;
            app.YLocationLabelEx1.Text = 'y(m)';

            app.ThetaLocationLabelEx1 = uilabel(swapGL_1);
            app.ThetaLocationLabelEx1.Enable = 'off';
            app.ThetaLocationLabelEx1.Layout.Row = 1;
            app.ThetaLocationLabelEx1.Layout.Column = 4;
            app.ThetaLocationLabelEx1.Text ='yaw(deg)';


            % Create StartLocationEditFieldEx1
            app.StartLocationXEditField = uieditfield(swapGL_1, 'text');
            app.StartLocationXEditField.Editable = 'off';
            app.StartLocationXEditField.Enable = 'off';
            app.StartLocationXEditField.Layout.Row = 2;
            app.StartLocationXEditField.Layout.Column = 2;

            app.StartLocationYEditField = uieditfield(swapGL_1, 'text');
            app.StartLocationYEditField.Editable = 'off';
            app.StartLocationYEditField.Enable = 'off';
            app.StartLocationYEditField.Layout.Row = 2;
            app.StartLocationYEditField.Layout.Column = 3;

            app.StartLocationTEditField = uieditfield(swapGL_1, 'text');
            app.StartLocationTEditField.Editable = 'off';
            app.StartLocationTEditField.Enable = 'off';
            app.StartLocationTEditField.Layout.Row = 2;
            app.StartLocationTEditField.Layout.Column = 4;


            % Create StartLocationEditFieldLabelEx1
            app.StartLocationEditFieldLabelEx1 = uilabel(swapGL_1);
            app.StartLocationEditFieldLabelEx1.Layout.Row = 2;
            app.StartLocationEditFieldLabelEx1.Layout.Column = 1;
            app.StartLocationEditFieldLabelEx1.Text = 'Start Location';

            % Create GoalLocationEditFieldLabelEx1

            app.GoalLocationXEditField = uieditfield(swapGL_1, 'text');
            app.GoalLocationXEditField.Editable = 'on';
            app.GoalLocationXEditField.ValueChangedFcn = createCallbackFcn(app, @GoalLocationXValueChangedFcn, true);
            app.GoalLocationXEditField.Tag = 'Ex1_x';
            app.GoalLocationXEditField.Layout.Row = 3;
            app.GoalLocationXEditField.Layout.Column = 2;

            app.GoalLocationYEditField = uieditfield(swapGL_1, 'text');
            app.GoalLocationYEditField.Editable = 'off';
            app.GoalLocationYEditField.Enable = 'off';
            app.GoalLocationYEditField.Layout.Row = 3;
            app.GoalLocationYEditField.Layout.Column = 3;

            app.GoalLocationTEditField = uieditfield(swapGL_1, 'text');
            app.GoalLocationTEditField.Editable = 'off';
            app.GoalLocationTEditField.Enable = 'off';
            app.GoalLocationTEditField.Layout.Row = 3;
            app.GoalLocationTEditField.Layout.Column = 4;

            app.KalmanFilterCheckBox = uicheckbox(swapGL_1);
            app.KalmanFilterCheckBox.Text = ' Optimal estimator';
            app.KalmanFilterCheckBox.Enable = 'on';
            app.KalmanFilterCheckBox.ValueChangedFcn = createCallbackFcn(app, @KalmanFilterValueChangedFcn, true);
            app.KalmanFilterCheckBox.Value = true;
            app.KalmanFilterCheckBox.Layout.Row = 3;
            app.KalmanFilterCheckBox.Layout.Column = 5;


            % Create GoalLocationEditFieldLabelEx1
            app.GoalLocationEditFieldLabelEx1 = uilabel(swapGL_1);
            app.GoalLocationEditFieldLabelEx1.Layout.Row = 3;
            app.GoalLocationEditFieldLabelEx1.Layout.Column = 1;
            app.GoalLocationEditFieldLabelEx1.Text = 'Goal Location';

%             app.UpdateGoalLocationVizEx1 = uibutton(editfieldLayout);         
%             app.UpdateGoalLocationVizEx1.Layout.Row = 3;
%             app.UpdateGoalLocationVizEx1.Layout.Column = 5;
%             app.UpdateGoalLocationVizEx1.Text = 'Update Map';
%             app.UpdateGoalLocationVizEx1.FontWeight = 'bold';

            % Create PlanaEgressPathButton
            buttonLayout = uigridlayout(gridlayout, [2 4]);
            buttonLayout.RowHeight = {'fit'};
            buttonLayout.ColumnWidth = {'fit', '1x', '1x', 'fit'};
            buttonLayout.Layout.Row = 8;
            buttonLayout.Layout.Column = [1 3];
            buttonLayout.BackgroundColor = 'white';
            app.PlanaEgressPathButton = uibutton(buttonLayout, 'push');
            app.PlanaEgressPathButton.Tag = 'plan_egress_path';
            app.PlanaEgressPathButton.FontWeight = 'bold';
            app.PlanaEgressPathButton.Layout.Row = 1;
            app.PlanaEgressPathButton.Layout.Column = 1;
            app.PlanaEgressPathButton.Text = 'Plan an Egress Path';
            app.PlanaEgressPathButton.ButtonPushedFcn = createCallbackFcn(app, @PlanaEgressPathButtonPushed, true);

            % Create SimulateButtonEx1
            app.SimulateButtonEx1 = uibutton(buttonLayout, 'push');
            app.SimulateButtonEx1.ButtonPushedFcn = createCallbackFcn(app, @SimulateButtonEx1ButtonDown, true);
            app.SimulateButtonEx1.Tag = 'simulate';
            app.SimulateButtonEx1.FontWeight = 'bold';
            app.SimulateButtonEx1.Layout.Row = 1;
            app.SimulateButtonEx1.Layout.Column = 4;
            app.SimulateButtonEx1.Text = 'Calibrate';

            back_buttonLayout = uigridlayout(gridlayout, [2 4]);
            back_buttonLayout.RowHeight = {'fit'};
            back_buttonLayout.ColumnWidth = {'fit', '1x', '1x', 'fit'};
            back_buttonLayout.Layout.Row = 10;
            back_buttonLayout.Layout.Column = [1 3];
            back_buttonLayout.BackgroundColor = 'white';

            % Create go to Exercise Menu button
            app.OpenModelButtonEx0 = uibutton(back_buttonLayout, 'push');
            app.OpenModelButtonEx0.ButtonPushedFcn = createCallbackFcn(app, @GoToMainMenu, true);
            app.OpenModelButtonEx0.Tag = 'back';
            %app.OpenModelButtonEx0.FontWeight = 'bold';
            app.OpenModelButtonEx0.Layout.Row = 1;
            app.OpenModelButtonEx0.Layout.Column = [1];
            app.OpenModelButtonEx0.Text = [char(10229) ' Exercise Menu'];

            %             StateComponents.StartLabel = app.StartLocationEditFieldLabelEx1;
            %             StateComponents.GoalLabel = app.GoalLocationEditFieldLabelEx1;
            %             StateComponents.StartX = app.StartLocationXEditField;
            %             StateComponents.StartY = app.StartLocationYEditField;
            %             StateComponents.StartT = app.StartLocationTEditField;
            %             StateComponents.GoalX = app.GoalLocationXEditField;
            %             StateComponents.GoalY = app.GoalLocationYEditField;
            %             StateComponents.GoalT = app.GoalLocationTEditField;
            %             StateComponents.Plan = app.PlanaEgressPathButton;
            %
            %             turnVisibility(app, StateComponents, 'off');
        end


        function createEx2Components(app, gridlayout)

            app.Ex2TitleLabel = uilabel(gridlayout);
            app.Ex2TitleLabel.Layout.Row = 1;
            app.Ex2TitleLabel.Layout.Column = [1 3];
            app.Ex2TitleLabel.Text = 'Exercise - 3: Object Detection';
            app.Ex2TitleLabel.FontWeight = 'Bold';

            exGL = uigridlayout(gridlayout, [3 4]);
            exGL.Layout.Row = 2;
            exGL.Layout.Column = [1 3];
            exGL.RowHeight = {'fit', 'fit', 'fit'};
            exGL.ColumnWidth = {'fit', 50, 50, 50};
            exGL.BackgroundColor = 'white';

            % Create CameraPanLabel
            app.CameraPanLabelEx2 = uilabel(exGL);
            app.CameraPanLabelEx2.Layout.Row = 1;
            app.CameraPanLabelEx2.Layout.Column = 1;
            app.CameraPanLabelEx2.Text = 'Camera Pan (-120 to 120 deg)';

            % Create CameraPanEditField1
            app.CameraPanEditField1Ex2 = uieditfield(exGL, 'text');
          %  app.CameraPanEditField1Ex2.ValueChangedFcn = createCallbackFcn(app, @CameraEx2ValueChanged1, true);
            app.CameraPanEditField1Ex2.Layout.Row = 1;
            app.CameraPanEditField1Ex2.Layout.Column = 2;
            app.CameraPanEditField1Ex2.Tag = 'Ex2pan1';

            % Create CameraPanEditLabel2
            app.CameraPanEditLabelEx2 = uilabel(exGL);
            app.CameraPanEditLabelEx2.Layout.Row = 1;
            app.CameraPanEditLabelEx2.Layout.Column = 3;
            app.CameraPanEditLabelEx2.Text = 'to';
            app.CameraPanEditLabelEx2.HorizontalAlignment = 'center';

            % Create CameraPanEditField2
            app.CameraPanEditField2Ex2 = uieditfield(exGL, 'text');
           % app.CameraPanEditField2Ex2.ValueChangedFcn = createCallbackFcn(app, @CameraEx2ValueChanged2, true);
            app.CameraPanEditField2Ex2.Layout.Row = 1;
            app.CameraPanEditField2Ex2.Layout.Column = 4;
            app.CameraPanEditField2Ex2.Tag = 'Ex2pan2';

            % Create Distance Threshold - 0.565
            app.DetectionThresholdLabel = uilabel(exGL);
            app.DetectionThresholdLabel.Layout.Row = 2;
            app.DetectionThresholdLabel.Layout.Column = 1;
            app.DetectionThresholdLabel.Text = 'Detection Threshold (0 to 1)';

            % Create CameraPanEditField1
            app.DetectionThresholdEditField = uieditfield(exGL, 'text');
           % app.DetectionThresholdEditField.ValueChangedFcn = createCallbackFcn(app, @DetectionThresholdEditFieldValueChanged, true);
            app.DetectionThresholdEditField.Layout.Row = 2;
            app.DetectionThresholdEditField.Layout.Column = 2;
            app.DetectionThresholdEditField.Tag = 'detection_threshold';

            % Create PlanaEgressPathButton
            buttonLayout = uigridlayout(gridlayout, [1 4]);
            buttonLayout.RowHeight = {'fit'};
            buttonLayout.ColumnWidth = {'fit', '1x', '1x', 'fit'};
            buttonLayout.Layout.Row = 3;
            buttonLayout.Layout.Column = [1 3];
            buttonLayout.BackgroundColor = 'white';

            % Create SimulateButtonEx1
            app.SimulateButtonEx2 = uibutton(buttonLayout, 'push');
            app.SimulateButtonEx2.ButtonPushedFcn = createCallbackFcn(app, @SimulateButtonEx2ButtonDown, true);
            app.SimulateButtonEx2.Tag = 'simulate';
            app.SimulateButtonEx2.FontWeight = 'bold';
            app.SimulateButtonEx2.Layout.Row = 1;
            app.SimulateButtonEx2.Layout.Column = 4;
            app.SimulateButtonEx2.Text = 'Detect';

            back_buttonLayout = uigridlayout(gridlayout, [1 4]);
            back_buttonLayout.RowHeight = {'fit'};
            back_buttonLayout.ColumnWidth = {'fit','fit','fit','fit'};
            back_buttonLayout.Layout.Row = 4;
            back_buttonLayout.Layout.Column = [1 3];
            back_buttonLayout.BackgroundColor = 'white';

            % Create go to Exercise Menu button
            app.OpenModelButtonEx0 = uibutton(back_buttonLayout, 'push');
            app.OpenModelButtonEx0.ButtonPushedFcn = createCallbackFcn(app, @GoToMainMenu, true);
            app.OpenModelButtonEx0.Tag = 'back';
            %app.OpenModelButtonEx0.FontWeight = 'bold';
            app.OpenModelButtonEx0.Layout.Row = 1;
            app.OpenModelButtonEx0.Layout.Column = [1];
            app.OpenModelButtonEx0.Text =  [char(10229) ' Exercise Menu'];
        end

        function createEx3Components(app, gridlayout)

            app.Ex2TitleLabel = uilabel(gridlayout);
            app.Ex2TitleLabel.Layout.Row = 1;
            app.Ex2TitleLabel.Layout.Column = [1 3];
            app.Ex2TitleLabel.Text = 'Exercise - 4: Navigation';
            app.Ex2TitleLabel.FontWeight = 'Bold';


            checkboxLayout = uigridlayout(gridlayout, [2 1]);
            checkboxLayout.Layout.Row = 2;
            checkboxLayout.Layout.Column = 1;
            checkboxLayout.RowHeight = {'fit'};
            checkboxLayout.ColumnWidth = {'fit'};
            checkboxLayout.BackgroundColor = 'white';

            % Create IncludeknownterrainobstaclesCheckBox
            app.IncludeknownterrainobstaclesCheckBox = uicheckbox(checkboxLayout);
            app.IncludeknownterrainobstaclesCheckBox.ValueChangedFcn = createCallbackFcn(app, @IncludeknownterrainobstaclesCheckBoxValueChanged, true);
            app.IncludeknownterrainobstaclesCheckBox.Text = 'Include known terrain obstacles';
            app.IncludeknownterrainobstaclesCheckBox.Layout.Row = 1;
            app.IncludeknownterrainobstaclesCheckBox.Layout.Column = 1;
            app.IncludeknownterrainobstaclesCheckBox.Value = true;

            % Create VisualizeunknownrocksCheckBox
            app.VisualizeunknownrocksCheckBox = uicheckbox(checkboxLayout);
            app.VisualizeunknownrocksCheckBox.ValueChangedFcn = createCallbackFcn(app, @VisualizeunknownrocksCheckBoxValueChanged, true);
            app.VisualizeunknownrocksCheckBox.Text = 'Visualize unknown terrain obstacles';
            app.VisualizeunknownrocksCheckBox.Layout.Row = 2;
            app.VisualizeunknownrocksCheckBox.Layout.Column = 1;
            app.VisualizeunknownrocksCheckBox.Value = true;

            % Create TerrainPointsBelowSlopeAngdegSliderLabel
            app.TerrainPointsBelowSlopeAngdegSliderLabel = uilabel(gridlayout);
            app.TerrainPointsBelowSlopeAngdegSliderLabel.HorizontalAlignment = 'right';
            app.TerrainPointsBelowSlopeAngdegSliderLabel.Layout.Row = 3;
            app.TerrainPointsBelowSlopeAngdegSliderLabel.Layout.Column = 1;
            app.TerrainPointsBelowSlopeAngdegSliderLabel.Text = 'Restrict Terrain Regions Using Slope Angle Threshold (deg)';
            
            % Create TerrainPointsBelowSlopeAngdegSlider
            sliderLayout = uigridlayout(gridlayout, [1 1]);
            sliderLayout.Layout.Row = 4;
            sliderLayout.Layout.Column = [1 4];
            sliderLayout.RowHeight = {'fit'};
            sliderLayout.ColumnWidth = {'1x'};
            sliderLayout.BackgroundColor = 'white';          

            app.TerrainPointsBelowSlopeAngdegSlider = uislider(sliderLayout);
            app.TerrainPointsBelowSlopeAngdegSlider.Limits = [20 40];
            app.TerrainPointsBelowSlopeAngdegSlider.MajorTicks = [20 25 30 35 40];
            app.TerrainPointsBelowSlopeAngdegSlider.MajorTickLabels = {'20', '25', '30', '35', '40'};
            app.TerrainPointsBelowSlopeAngdegSlider.ValueChangedFcn = createCallbackFcn(app, @TerrainPointsBelowSlopeAngdegSliderValueChanged, true);
            app.TerrainPointsBelowSlopeAngdegSlider.MinorTicks = [];
            app.TerrainPointsBelowSlopeAngdegSlider.Tag = 'MaxSlopeAng';
            app.TerrainPointsBelowSlopeAngdegSlider.FontWeight = 'bold';
            app.TerrainPointsBelowSlopeAngdegSlider.Layout.Row = 1;
            app.TerrainPointsBelowSlopeAngdegSlider.Layout.Column = 1;
            app.TerrainPointsBelowSlopeAngdegSlider.Value = 40;

            editfieldLayout = uigridlayout(gridlayout, [4 5]);
            editfieldLayout.Layout.Row = [5 6];
            editfieldLayout.Layout.Column = [1 4];
            editfieldLayout.BackgroundColor = 'white';
            editfieldLayout.RowHeight = {'1x', '1x', '1x'};
            editfieldLayout.ColumnWidth = {'fit',50, 50, 50};

            app.XLocationLabel = uilabel(editfieldLayout);
            app.XLocationLabel.Enable = 'off';
            app.XLocationLabel.Layout.Row = 1;
            app.XLocationLabel.Layout.Column = 2;
            app.XLocationLabel.Text = 'x(m)';

            app.YLocationLabelEx1 = uilabel(editfieldLayout);
            app.YLocationLabelEx1.Enable = 'off';
            app.YLocationLabelEx1.Layout.Row = 1;
            app.YLocationLabelEx1.Layout.Column = 3;
            app.YLocationLabelEx1.Text = 'y(m)';

            app.ThetaLocationLabel = uilabel(editfieldLayout);
            app.ThetaLocationLabel.Enable = 'off';
            app.ThetaLocationLabel.Layout.Row = 1;
            app.ThetaLocationLabel.Layout.Column = 4;
            app.ThetaLocationLabel.Text ='yaw(deg)';


            app.StartLocationxyEditFieldLabel = uilabel(editfieldLayout);
            app.StartLocationxyEditFieldLabel.Enable = 'off';
            app.StartLocationxyEditFieldLabel.Layout.Row = 2;
            app.StartLocationxyEditFieldLabel.Layout.Column = 1;
            app.StartLocationxyEditFieldLabel.Text = 'Current Location';

            % Create StartLocationxyEditField
            app.StartLocationXEditFieldEx3 = uieditfield(editfieldLayout, 'text');
            app.StartLocationXEditFieldEx3.Editable = 'off';
            app.StartLocationXEditFieldEx3.Enable = 'off';
            app.StartLocationXEditFieldEx3.Layout.Row = 2;
            app.StartLocationXEditFieldEx3.Layout.Column = 2;

            app.StartLocationYEditFieldEx3 = uieditfield(editfieldLayout, 'text');
            app.StartLocationYEditFieldEx3.Editable = 'off';
            app.StartLocationYEditFieldEx3.Enable = 'off';
            app.StartLocationYEditFieldEx3.Layout.Row = 2;
            app.StartLocationYEditFieldEx3.Layout.Column = 3;

            app.StartLocationTEditFieldEx3 = uieditfield(editfieldLayout, 'text');
            app.StartLocationTEditFieldEx3.Editable = 'off';
            app.StartLocationTEditFieldEx3.Enable = 'off';
            app.StartLocationTEditFieldEx3.Layout.Row = 2;
            app.StartLocationTEditFieldEx3.Layout.Column = 4;

            % Create GoalLocationxyEditFieldLabel
            app.GoalLocationxyEditFieldLabel = uilabel(editfieldLayout);
            app.GoalLocationxyEditFieldLabel.Layout.Row = 3;
            app.GoalLocationxyEditFieldLabel.Layout.Column = 1;
            app.GoalLocationxyEditFieldLabel.Text = 'Goal Location ';

            % Create GoalLocationxyEditField
            app.GoalLocationXEditFieldEx3 = uieditfield(editfieldLayout, 'text');
          %  app.GoalLocationXEditFieldEx3.ValueChangedFcn = createCallbackFcn(app, @GoalLocationEx3XValueChangedFcn, true);
            app.GoalLocationXEditFieldEx3.Editable = 'on';
            app.GoalLocationXEditFieldEx3.Layout.Row = 3;
            app.GoalLocationXEditFieldEx3.Layout.Column = 2;

            app.GoalLocationYEditFieldEx3 = uieditfield(editfieldLayout, 'text');
          %  app.GoalLocationYEditFieldEx3.ValueChangedFcn = createCallbackFcn(app, @GoalLocationEx3YValueChangedFcn, true);
            app.GoalLocationYEditFieldEx3.Editable = 'on';
            app.GoalLocationYEditFieldEx3.Layout.Row = 3;
            app.GoalLocationYEditFieldEx3.Layout.Column = 3;

            app.GoalLocationTEditFieldEx3 = uieditfield(editfieldLayout, 'text');
           % app.GoalLocationTEditFieldEx3.ValueChangedFcn = createCallbackFcn(app, @GoalLocationEx3TValueChangedFcn, true);
            app.GoalLocationTEditFieldEx3.Editable = 'on';
            app.GoalLocationTEditFieldEx3.Layout.Row = 3;
            app.GoalLocationTEditFieldEx3.Layout.Column = 4;

            app.UpdateGoalLocationViz = uibutton(editfieldLayout);         
            app.UpdateGoalLocationViz.Layout.Row = 4;
            app.UpdateGoalLocationViz.Layout.Column = 5;
            app.UpdateGoalLocationViz.Text = 'Update Map';
            app.UpdateGoalLocationViz.ButtonPushedFcn = createCallbackFcn(app, @UpdateGoalLocationVizButtonPushed, true);
            app.UpdateGoalLocationViz.FontWeight = 'bold';


            % Create PickGoalpointsinMapCheckBox
            app.PickGoalpointsinMapCheckBox = uicheckbox(editfieldLayout);
            app.PickGoalpointsinMapCheckBox.ValueChangedFcn = createCallbackFcn(app, @PickGoalpointsinMapCheckBoxValueChanged, true);           
            app.PickGoalpointsinMapCheckBox.Text = 'Pick a goal location in Map';
            app.PickGoalpointsinMapCheckBox.Layout.Row = 4;
            app.PickGoalpointsinMapCheckBox.Layout.Column = [1 4];

            % Create PlanPathButton_2
            buttonLayout = uigridlayout(gridlayout, [1 4]);
            buttonLayout.Layout.Row = 8;
            buttonLayout.Layout.Column = [1 4];
            buttonLayout.BackgroundColor = 'white';
            buttonLayout.RowHeight = {'1x'};
            buttonLayout.ColumnWidth = {'fit', '1x', '1x', 'fit'};
            app.PlanPathButtonEx3 = uibutton(buttonLayout, 'push');
            app.PlanPathButtonEx3.Tag = 'path_plan';
            app.PlanPathButtonEx3.FontWeight = 'bold';
            app.PlanPathButtonEx3.Layout.Row = 1;
            app.PlanPathButtonEx3.Layout.Column = 1;
            app.PlanPathButtonEx3.Text = 'Plan Path';
            app.PlanPathButtonEx3.ButtonPushedFcn = createCallbackFcn(app, @PlanPathButtonPushed, true);
            
            % Create SimulateButton_2
            app.SimulateButtonEx3 = uibutton(buttonLayout, 'push');
            app.SimulateButtonEx3.ButtonPushedFcn = createCallbackFcn(app, @SimulateButtonEx3ButtonDown, true);
            app.SimulateButtonEx3.Tag = 'simulate';
            app.SimulateButtonEx3.FontWeight = 'bold';
            app.SimulateButtonEx3.Layout.Row = 1;
            app.SimulateButtonEx3.Layout.Column = 4;
            app.SimulateButtonEx3.Text = 'Simulate';

            back_buttonLayout = uigridlayout(gridlayout, [1 4]);
            back_buttonLayout.RowHeight = {'fit'};
            back_buttonLayout.ColumnWidth = {'fit','fit','fit','fit'};
            back_buttonLayout.Layout.Row = 9;
            back_buttonLayout.Layout.Column = [1 4];
            back_buttonLayout.BackgroundColor = 'white';

            % Create go to Exercise Menu button
            app.OpenModelButtonEx0 = uibutton(back_buttonLayout, 'push');
            app.OpenModelButtonEx0.ButtonPushedFcn = createCallbackFcn(app, @GoToMainMenu, true);
            app.OpenModelButtonEx0.Tag = 'back';
            %app.OpenModelButtonEx0.FontWeight = 'bold';
            app.OpenModelButtonEx0.Layout.Row = 1;
            app.OpenModelButtonEx0.Layout.Column = [1];
            app.OpenModelButtonEx0.Text = [char(10229) ' Exercise Menu'];

        end
    end

    methods (Access = private)
        function turnVisibility(app, stateComponents, flag)
            cellS = struct2cell(stateComponents);
            for i = 1:length(cellS)
                cellS{i}.Visible = flag;
            end
        end

        function enableEx2ComponentsDuringSimulation(app,flag)

            app.CameraPanEditField1Ex2.Enable = flag;
            app.CameraPanEditField2Ex2.Enable = flag;
            app.DetectionThresholdEditField.Enable = flag;   
            app.SimulateButtonEx2.Enable = flag;

        end

        function enableEx1ComponentsDuringSimulation(app,flag)

            app.CameraPanEditField1Ex1.Enable = flag;
            app.CameraPanEditField2Ex1.Enable = flag;
            app.CameraPitchEditField.Enable = flag;
            app.GoalLocationXEditField.Enable = flag;
            app.PlanaEgressPathButton.Enable = flag;
            app.PlanaEgressPathButton.Enable = flag;
            app.SimulateButtonEx1a.Enable = flag ;
            app.SimulateButtonEx1.Enable = false ;
            app.KalmanFilterCheckBox.Enable = flag ;

        end

        function enableEx3ComponentsDuringSimulation(app,flag)

            app.GoalLocationXEditFieldEx3.Enable = flag;
            app.GoalLocationYEditFieldEx3.Enable = flag;
            app.GoalLocationTEditFieldEx3.Enable = flag;
            app.TerrainPointsBelowSlopeAngdegSlider.Enable = flag;
            app.IncludeknownterrainobstaclesCheckBox.Enable = flag;
            app.VisualizeunknownrocksCheckBox.Enable = flag;
            app.PlanPathButtonEx3.Enable = flag;
            app.SimulateButtonEx3.Enable = false ;
            app.PickGoalpointsinMapCheckBox.Enable = flag;
            app.UpdateGoalLocationViz.Enable = flag;

        end

    end
end
