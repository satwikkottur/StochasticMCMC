function [y, X] = generateDataset(dataPath)
    [y, X] = libsvmread(dataPath);
    
%     noTrain = uint32(0.9 * length(y));
% noTest = length(y) - noTrain;
% perm = randperm(length(y));
% 
% train = perm(1:noTrain);
% test = perm(end-noTest+1:end);
% 
% yTrain = y(train);
% XTrain = X(train, :);
% libsvmwrite('/Users/skottur/CMU/Sem2/graphicalModels/Datasets/cpusmall/train.txt', ...
%                     yTrain, XTrain);
% 
% yTest = y(test);
% XTest = X(test, :);
% libsvmwrite('/Users/skottur/CMU/Sem2/graphicalModels/Datasets/cpusmall/test.txt', ...
%                 yTest, XTest);

end

