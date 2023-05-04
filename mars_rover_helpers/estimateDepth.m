function [I, obstacleCoordinates,obstacleDistance] = estimateDepth(I_left,disparityMap,points3D,bboxes_set)

% Function to estimate depth using the disparity map and a 3D point cloud
% reconstructed using stereo vision.

% Copyright 2022-2023 The MathWorks, Inc

labels = {};
centroids_set = {};

for i = 1:size(bboxes_set,1)

    bboxes = bboxes_set(i,:);

    % Find the centroids of detected obstacle.
    centroids_set{i} = [round(bboxes(:, 1) + bboxes(:, 3) / 2), ...
        round(bboxes(:, 2) + bboxes(:, 4) / 2)];
    centroids = centroids_set{i};
    
    if centroids(1)> size(disparityMap,2)
        centroids(1) = size(disparityMap,2);
    end

    if centroids(2)> size(disparityMap,1)
        centroids(2) = size(disparityMap,1);
    end

    % Find the 3-D coordinates of the centroids wrt rover camera in image
    % ref frame
    centroidsIdx = sub2ind(size(disparityMap), centroids(:, 2), centroids(:, 1));
    X = points3D(:,:,1);
    Y = points3D(:,:,2);
    Z = points3D(:,:,3);
    centroids3D = [X(centroidsIdx)'; Y(centroidsIdx)'; Z(centroidsIdx)'];

    % Find the distances from the camera in meters.
    obstacleDisRover = sqrt(sum(centroids3D .^ 2));

    % Display the detected obstacles and their distances.
    labels{i} = sprintf('%0.2f meters', obstacleDisRover);
    obstacleCoordinates(i,:) = centroids3D;
    obstacleDistance(i) = double(obstacleDisRover);

end

if ~isempty(bboxes_set)
    I = insertObjectAnnotation(I_left, 'rectangle', vertcat(bboxes_set), labels);
    I = insertMarker(I,vertcat(centroids_set{:}));
else
    I = I_left;
end

end