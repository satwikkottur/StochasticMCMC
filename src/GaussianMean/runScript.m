% Default script to be run for test/debugging purposes
close all
tic;

noDims = 2; % Number of dimensions
noSamples = 100000; % Number of samples

% Create the dataset
[data, truePDF] = generateDataset(noDims, noSamples); 

% Running HMC, select with gradient or stochastic gradient
prob = @likelihood;
%gradProb = @gradLikelihood;
gradProb = @stocGradLikelihood;

% Initializing the options (manually done checking the code in hmc)
options = -1 * ones(18, 1);
options(9) = 0; % false
options(14) = 100000; % Run for 50000 iterations
options(15) = 50; % burn in
options(7) = 10; % Number of leap steps
options(1) = 0; % Display 
options(18) = 0.0001;

% Relatively good prior
priorPDF = struct('mean', 0.5 * ones(1, noDims), ...
                'variance', eye(noDims), ...
                'precision', eye(noDims));
            
% Generating multiple samples
noMCMC = 1;
mcmcSamples = zeros(noMCMC, noDims);

% Infomation for selecting the batches
batchSize = 20;
batchSelect = 1;  % 1 for random and 2 for linear
batchInfo = struct('size', batchSize, 'select', batchSelect);

for i = 1:noMCMC
    initGuess = rand(1, noDims);
    [samples, energies, diagn] = hmc(prob, initGuess, options, gradProb, ...
                                      data, priorPDF, truePDF, batchInfo);
    % Selecting the batches at 'random' or in a 'linear' way
    
    mcmcSamples = samples(1:100:size(samples, 1), :);
end

% Verify samples
generatePlots(data, mcmcSamples, truePDF, priorPDF, initGuess);
%generateTrajectory(data, samples, truePDF);                                                
toc
