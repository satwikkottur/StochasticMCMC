% Default script to be run for test/debugging purposes
%close all
display('Running Bayesian Lasso');
tic;
stochastic = 0;

noDims = 20; % Number of dimensions
noSamples = 10000; % Number of samples

% Create the dataset
[X, y, trueBeta, trueSigmaSq] = generateDataset(noDims, noSamples); 
% Splitting between training and testing
train = 1:noSamples*0.8;
XTrain = X(train, :);
yTrain = y(train);

XTest = X(train(end)+1:end, :);
yTest = y(train(end)+1:end);

% Running HMC, select with gradient or stochastic gradient
prob = @likelihood;
if (stochastic)
    gradProb = @stocGradLikelihood;
else
    gradProb = @gradLikelihood;
end

% Initializing the options (manually done checking the code in hmc)
options = -1 * ones(18, 1);
options(9) = 0; % false
options(14) = 100000; % Run for 50000 iterations
options(15) = 1; % burn in
options(7) = 1; % Number of leap steps
options(1) = 0; % Display 
options(18) = 1e-3; %step size

% Infomation for selecting the batches
batchSize = 30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generating the fisher matrix
% Use mle mean and mle variance
% mleMean = mean(data);
% shifted = bsxfun(@minus, data, mleMean);
% mleVar = 1/size(data, 1) * sum(sum(shifted .* shifted));
% 
% gaussian = struct('type', 'mGaussMean', 'variance', mleVar, ...
%                 'dimensions', noDims);
% % gaussian = struct('type', 'mGaussMeanSigma', 'variance', mleVar, ...
% %     'dimensions', noDims+1);
% fisher = getFisherMatrix(gaussian);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initGuess = rand(1, noDims + 1);
lambda = 0.1;

% Stochastic
if (stochastic)
    [samples, energies, diagn] = shmc(prob, initGuess, options, gradProb, ...
                                data, priorPDF, batchSize, fisher, []);
else
    [samples, energies] = hmc(prob, initGuess, options, gradProb, ...
                                 XTrain, yTrain, lambda, []);    
end
    
% Verify samples
generatePlots(XTest, yTest, samples);
rejectionAnalysis
%generateTrajectory(data, samples, truePDF);                                                
toc