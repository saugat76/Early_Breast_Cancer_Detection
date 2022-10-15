close all;

rootFolder = fullfile('Datastore');

categories = {'Benign', 'Malignant'};

imds = imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');

label_count = countEachLabel(imds);   %count the no of images for each classes
minCount = min(label_count{:,2});
imds = splitEachLabel(imds, minCount, "randomized"); %split the dataset randomly limiting all 
                                                     % classes to have equal no of image
    
net = alexnet();
% net.Layer(1)
% net.layer(2)

[trainingData, testData] = splitEachLabel(imds, 0.8, 'randomized');

imageSize = [512 512 3];  %Keeping the original image size                
                                                                            
augmentedTrain = augmentedImageDatastore(imageSize,trainingData, 'ColorPreprocessing','gray2rgb');
augmentedTest = augmentedImageDatastore(imageSize,testData,'ColorPreprocessing','gray2rgb');

layersTransfer = net.Layers(2:end-3);
layers = [
    imageInputLayer([512,512,3]);
    layersTransfer
    fullyConnectedLayer(numel(categories))
    softmaxLayer
    classificationLayer];

plot(layerGraph(layers));

opts = trainingOptions("sgdm",...
    "ExecutionEnvironment","parallel",...
    "InitialLearnRate",1e-05,...
    "MaxEpochs",40,...
    "Shuffle","every-epoch",...
    "Plots","training-progress",...
    "ValidationData",augmentedTest);

[net, traininfo] = trainNetwork(augmentedTrain,layers,opts);

