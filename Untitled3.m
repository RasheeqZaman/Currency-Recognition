
folder = 'C:\Users\Rsq Zmn\Documents\GitHub\Currency-Indentification\trainingDataset\d2\';

trainingSetDir   = fullfile(pwd, 'trainingDataset', '50 taka');
trainingSet = imageDatastore(trainingSetDir);
numImages = numel(trainingSet.Files);

for i=1:numImages
    image = readimage(trainingSet, i);
    image = imresize(image, [325 720]);
    newimagename = [folder 'train' num2str(i) '.jpg'];
    imwrite(image,newimagename);
end