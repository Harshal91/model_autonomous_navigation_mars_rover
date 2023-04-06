% This code sweeps multiple values of the detection threshold. We need to
% determine its optimal value, so we maximize the number of bounding boxes
% that overlap with the ones from the labeled dataset.

% Copyright 2022-2023 The MathWorks, Inc

clear
load data
rng(0, 'twister');
% Set validation partition to 2.5%. Keep in mind that we have stereo
% images, which means that we need to remove both Left and Right images for
% validation. This means that, in the end, we will have somewhere between
% 2.5 and 5% of validation data.
valThreshold = 0.025;
[trainIdx, valIdx] = validationSplit(data, valThreshold);

% Load the detector
load defaultDetector.mat

% Select a subset of the existing images for the detection. We choose only
% N images for this computation.
N = 500;
trainSubset = data.Filename(trainIdx);
p = randperm(numel(trainSubset),N);
trainSubset = trainSubset(p);
data = data(p, :);

availableThresholds = 0.1:0.05:0.9;

for imgIdx = 1:N
    img = imread(data.Filename{imgIdx});

    % Read the labelled imagesc, which includes rocks that were not used as
    % labels.
    targetImg = imread(data.Mask{imgIdx});
    targetImg= im2gray(targetImg)>0;

    % Overlap the previous mask with our target bboxes to keep only the
    % rock labels.
    targetBboxes = data.rock(imgIdx);
    targetBboxes = targetBboxes{1};
    originalBboxMask = zeros(size(img));
    targetBboxesImg = insertShape(originalBboxMask,"filledrectangle",targetBboxes);
    targetBboxesImg = im2gray(targetBboxesImg)>0;

    targetImg = targetBboxesImg.*targetImg;


    for aucIdx = 1:numel(availableThresholds)
        % Predict the bounding box using our detector
        selectedThreshold = availableThresholds(aucIdx);
        [predBboxes, scores] = detector.detect(img, 'Threshold', selectedThreshold);

        % Create a mask using the detected bounding boxes to check if they overlap
        % with the original ones. For this, we create a binary mask with all the
        % bounding boxes we detected using our model.
        predMask = zeros(size(img));
        detectedBboxesImg = insertShape(predMask,"filledrectangle",predBboxes);
        detectedBboxesImg = im2gray(detectedBboxesImg)>0; 

        % Start computing the Jaccard index between the target bbox mask and our
        % predicted bbox mask.
        jaccardValues(imgIdx, aucIdx) = jaccard(targetBboxesImg, detectedBboxesImg);

        % Compute intersection
        intersectionValues(imgIdx, aucIdx) = sum(targetBboxesImg(:).*detectedBboxesImg(:))/numel(targetBboxesImg);
    end
end

%% Plots
figure
plot(availableThresholds, sum(jaccardValues)/N, '*-r', 'LineWidth', 2);
ylabel('Jaccard index');
xlabel('Threshold');
