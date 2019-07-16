trainPath = fullfile(pwd, 'newTrainingDataset');
testPath = fullfile(pwd, 'testDataset');
imds =imageDatastore(trainPath,   'IncludeSubfolders', true, 'LabelSource', 'foldernames');
imds1 =imageDatastore(testPath,   'IncludeSubfolders', true, 'LabelSource', 'foldernames');




labelCount = countEachLabel(imds);
labelCount1 = countEachLabel(imds1);



img = readimage(imds,1);
size(img);

numTrainFiles = 41;
[imdsTrain] = splitEachLabel(imds,numTrainFiles,'randomize');

numTestFiles = 1;
[imdsValidation] = splitEachLabel(imds1,numTestFiles,'randomize');




layers = [
    imageInputLayer([325 720 3])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false);
net = trainNetwork(imdsTrain,layers,options);

YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation);


