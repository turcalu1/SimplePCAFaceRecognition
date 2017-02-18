close all;

testDir = 'test';
imageDir = 'train';
numberOfEigenFaces = 5;
[tImageFiles, ...
 tAverageFaceVector, ... 
 tEigenFacesOriginalDimension, ... 
 tProjectedImages, ...
 tImageSize] = Train(imageDir, numberOfEigenFaces);
   

figure;
for i=1:numberOfEigenFaces
    subplot(2,3,i);
    imagesc(reshape(tEigenFacesOriginalDimension(:, i), tImageSize)); axis image; colormap(gray);
    set(gca, 'xticklabel', ''); 
    set(gca, 'yticklabel', ''); 
    xlabel(sprintf('Eigenface %d', i));
end