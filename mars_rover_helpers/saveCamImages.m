function state = saveCamImages(state)
    
% Function to save training data images for DL network.

% Copyright 2022-2023 The MathWorks, Inc

imageNames = {'LeftNavCam','RightNavCam','LeftBinaryMaskNavCam','RightBinaryMaskNavCam'};

for img_id = 1:length(imageNames)

    fh = findobj( 'Type', 'Figure', 'Name', imageNames{img_id});

    switch fh.Name

        case 'LeftNavCam'

            saveImgName = ['OriginalImages',filesep,'L',filesep,...
                'L_x',num2str(state.rover_path.x),...
                'y',num2str(state.rover_path.y),...
                'b',num2str(state.cam_base_angle),...
                't',num2str(state.cam_target_angle),'.png'];


        case  'RightNavCam'

            saveImgName = ['OriginalImages',filesep,'R',filesep,...
                'R_x',num2str(state.rover_path.x),...
                'y',num2str(state.rover_path.y),...
                'b',num2str(state.cam_base_angle),...
                't',num2str(state.cam_target_angle),'.png'];

        case  'LeftBinaryMaskNavCam'

            saveImgName = ['BinaryMaskImages',filesep,'L',filesep,...
                'L_mask_x',num2str(state.rover_path.x),...
                'y',num2str(state.rover_path.y),...
                'b',num2str(state.cam_base_angle),...
                't',num2str(state.cam_target_angle),'.png'];

        case  'RightBinaryMaskNavCam'

            saveImgName = ['BinaryMaskImages',filesep,'R',filesep,...
                'R_mask_x',num2str(state.rover_path.x),...
                'y',num2str(state.rover_path.y),...
                'b',num2str(state.cam_base_angle),...
                't',num2str(state.cam_target_angle),'.png'];
        otherwise
            error('Incorrect ImageType');
    end

    filepath = tempdir;
    imagePath = [filepath,filesep,saveImgName];
    imwrite(getframe(fh).cdata,imagePath);

    state.savedImages{img_id} = imagePath;

end

close all;

end