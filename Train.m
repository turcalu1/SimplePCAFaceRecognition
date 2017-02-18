function [tImageFiles, tAverageFaceVector, tEigenFacesOriginalDimension, tProjectedImages, tImageSize] = Train(imageDir, numberOfEigenFaces)
% Train - Computes Principal Components from the given images
%   CONSTRAINTS:
%   1) The all images should have the same dimensions
%   2) Function looks only for *.jpg images
%
%   The computation proceeds in the following steps:
%    1) All images are put into one matrix (A) as row vectors 
%    2) This matrix is used for calculating the covariance matrix.
%       C = A' * A is utilized instead of C = A * A' in order to save computing
%       time / memory.
%    3) Eigen Vectors of the covariance matrix are Eigen Faces (AKA
%       Principal Components), Eigen Values are directly proportional to
%       the variance of Eigen Faces
%    4) Projecting Images into PCA Space
%     
%   PARAMETERS:
%    i imageDir - Directory with *.jpg images
%    i numberOfEigenFaces - This value should be < number of images
%    o tImageFiles - Output of dir command
%    o tAverageFaceVector - Mean of all image files converted to grey
%                           scale
%    o tEigenFacesOriginalDimension - Principal Components
%    o tProjectedImages - Projected images into the PCA Space
%    o tImageSize - Dimensions of image (should be the same for the all images)
% 
%   EXAMPLES:
%     >> output = Train('train', nu8mberOfEigenFaces);
% 
%   LEARN MORE ABOUT PCA:
%   https://www.youtube.com/watch?v=kw9R0nD69OU
%   https://www.youtube.com/watch?v=_nZUhV-qhZA
%   https://www.youtube.com/watch?v=kuzJJgPBrqc

% Load faces
tImageFiles = dir( [imageDir filesep '*.jpg'] );
imageCnt = length(tImageFiles);
faces = [];
tic
for i=1:imageCnt
    im = double(rgb2gray(imread([imageDir filesep tImageFiles(i).name])));
    faces = [faces im(:)];
end
tImageSize = size(im);

% Get Covariance Matrix
tAverageFaceVector = mean(faces, 2);
% imshow(uint8(reshape(tAverageFaceVector, tImageSize)));
normalizedFaceVectors = faces - repmat(tAverageFaceVector, 1, imageCnt);
covarianceMatrix = normalizedFaceVectors' * normalizedFaceVectors;

% Get (numberOfEigenFaces) EigenFaces in the original dimension 
[V,D] = eig(covarianceMatrix);
eigenFaces = V(end-numberOfEigenFaces+1:end, :);
tEigenFacesOriginalDimension = normalizedFaceVectors * eigenFaces';
normalizedFaceVectors * eigenFaces';

% Project normalized faces to the PCA Space
tProjectedImages = tEigenFacesOriginalDimension'*normalizedFaceVectors;