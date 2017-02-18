%%
%% Example script for testing the face recognition functions
%%
%% Script creates PCA Space from *.jpg images in 'train' and then tries 
%% to recognize a several images in 'test'
%%
WEIGHT_DIFFERENCE_THRESHOLD = 100000000;

close all;

testDir = 'test';
imageDir = 'train';
numberOfEigenFaces = 4;
[tImageFiles, ...
 tAverageFaceVector, ... 
 tEigenFacesOriginalDimension, ... 
 tProjectedImages, ...
 tImageSize] = Train(imageDir, numberOfEigenFaces);

for i = 1:2
    testImageName = sprintf('%d.jpg', i);
    testImageSrc = [testDir filesep testImageName];

    tRecognizedImageIdx = FaceRecognition(testImageSrc, ...
                                          tAverageFaceVector, ... 
                                          tEigenFacesOriginalDimension, ... 
                                          tProjectedImages, ...
                                          WEIGHT_DIFFERENCE_THRESHOLD);
    
    if tRecognizedImageIdx == 0 
        fprintf('Unable to recognize face! \n');
    else
        fprintf('Recognized face ID: %d \n', tRecognizedImageIdx);
        figure;
        
        % Show input & recognized image
        subplot(1,2,1);
        imshow(imread([testDir filesep testImageName]));
        set(gca, 'xticklabel', ''); set(gca, 'yticklabel', ''); 
        xlabel('Original Image');

        recognizedImageSrc = [imageDir filesep tImageFiles(tRecognizedImageIdx).name];
        subplot(1,2,2);
        imshow(imread(recognizedImageSrc));
        set(gca, 'xticklabel', ''); set(gca, 'yticklabel', ''); 
        imginfo = imfinfo(recognizedImageSrc);
        xlabel(sprintf('Recognized Person: %s', char(imginfo.Comment)));
    end
end