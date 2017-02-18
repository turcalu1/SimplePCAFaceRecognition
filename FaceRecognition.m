function tRecognizedImageIdx = FaceRecognition(testImageSrc, ...
                                                 tAverageFaceVector, ...
                                                 tEigenFacesOriginalDimension, ...
                                                 tProjectedImages, ...
                                                 imageDiffThreshold)
% FaceRecognition - Recognizes a face by using precalculated Principal
% Components.
%     
%   PARAMETERS:
%    i testImageSrc - Location of the testing image
%    o tAverageFaceVector
%    o tEigenFacesOriginalDimension
%    i tProjectedImages
%    i imageDiffThreshold - Maximum allowed difference (Euclidean Distance) 
%                           between the recognized and testing image
%    o tRecognizedImageIdx - ID of recognized face (it's order wihthin the train directory), 
%                            if 0 the face wasn't recognized at all
% 
%   EXAMPLES:
%     >>     tRecognizedImageIdx = FaceRecognition(testImageSrc, ...
%                                                  tAverageFaceVector, ... 
%                                                  tEigenFacesOriginalDimension, ... 
%                                                  tProjectedImages, ...
%                                                  WEIGHT_DIFFERENCE_THRESHOLD);
                                             
iToRecognize = double(rgb2gray(imread(testImageSrc)));
iToRecognize = iToRecognize(:);

% Project normalized image to the PCA Space
iNormalized = iToRecognize - tAverageFaceVector;
iProjectedImage = tEigenFacesOriginalDimension'*iNormalized;

% Choose image with a closest vector
tRecognizedImageIdx = 0;
currentImageDiff = imageDiffThreshold;
for i=1:size(tProjectedImages, 2)
    % Euclidean distance
    imageDiff = sqrt( sum ( (iProjectedImage - tProjectedImages(:, i)) .^ 2 ) );
    % fprintf('i: %d \t weightDiff: %.5f \n', i, imageDiff);
    if  imageDiff <= currentImageDiff
        tRecognizedImageIdx = i;
        currentImageDiff = imageDiff;
    end
end