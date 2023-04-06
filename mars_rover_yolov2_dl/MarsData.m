% Script used to get paths from images and masks, as well as extracting
% bounding boxes after performing a morphological opening.

% Copyright 2022-2023 The MathWorks, Inc

maskImageDir = 'data/BinaryMaskImages';
imageDir = 'data/OriginalImages';

% Get list of files and folders in any subfolder
MaskImageList = dir(fullfile(maskImageDir, '**/*.png'));
ImageList = dir(fullfile(imageDir, '**/*.png'));

% Create the array that we will use to create our image/bbox datastores. It
% contains a field for the file name, the bounding boxes (named rock) and
% the mask image path.
data = array2table(zeros(0,3));
data.Properties.VariableNames = ["Filename", "rock", "Mask"];


for k = 1:numel(MaskImageList) % all the files under the directory
    try
        % Generate hte path of the image and the mask
        MaskImagePath = fullfile(MaskImageList(k).folder, MaskImageList(k).name);
        ImagePath = fullfile(ImageList(k).folder, ImageList(k).name);

        % Read the image and performe some morphological opening using a
        % spherical structural element.
        im = imread(MaskImagePath);
        se = strel('sphere', 2);

        % Opening: first erode, then dilate
        imgOpen = imopen(im, se);

        % Generate some label for each item of the mask. Then, for each
        % region get both area and bounding box.
        L = bwlabel(imgOpen(:,:,1));
        prop=regionprops(L,{'Area','BoundingBox'}); 

        % Concatenate both areas and bboxes into a more manageable
        % data structure.
        bbox = cat(1, prop.BoundingBox);
        areas = cat(1, prop.Area);

        % We want to keep only the areas bigger than 100 pixels.
        % Otherwise, we spend resources training on objects that are
        % just too small. 
        minAreaSize = 100; % Pixels
        bbox = bbox(areas > minAreaSize, :);

        % Check the dimension of the bounding boxes. It should be a matrix
        % with dimensions Nx4. If a bounding box doesn't comply, we just
        % don't keep it. This also applies for images where no bounding box
        % exists (e.g. when there is no rocks in the scene).
        if size(bbox, 2) ~=4 || isempty(bbox)
            fprintf("The following mask is producing erroneous bounding boxes:\n%s. Skipping.\n", MaskImageList(k).name);
            im = imread(ImagePath);
            plotBbox(im, bbox);
        else
            % If the bounding box is non-empty and has the right
            % dimensions, store it.
            data = [data; struct2table(struct("Filename", ImagePath, "rock", {{bbox}}, "Mask", MaskImagePath), 'AsArray', true)];
        end
    end
end

% Save the data struct with our paths and bounding boxes.
save data data
