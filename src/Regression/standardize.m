% Function to standardize and save the dataset
%XMean = mean(XTrain, 1);
XStd = std(XTrain, 1);
yMean = mean(yTrain);

%XTrain = bsxfun(@minus, XTrain, XMean);
XTrain = bsxfun(@rdivide, XTrain, XStd);
yTrain = yTrain - yMean;

%XTest = bsxfun(@minus, XTest, XMean);
XTest = bsxfun(@rdivide, XTest, XStd);
yTest = yTest - yMean;

%XVal = bsxfun(@minus, XVal, XMean);
XVal = bsxfun(@rdivide, XVal, XStd);
yVal = yVal - yMean;

% Saving the datasets
libsvmwrite(fullfile(dataPath, 'trainStand.txt'), yTrain, XTrain);
libsvmwrite(fullfile(dataPath, 'testStand.txt'), yTest, XTest);
libsvmwrite(fullfile(dataPath, 'valStand.txt'), yVal, XVal);





