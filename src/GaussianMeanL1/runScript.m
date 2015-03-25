% Default script to be run for test/debugging purposes
close all
display('Running Bayesian Lasso');
tic;

noDims = 1000; % Number of dimensions
noSamples = 1000; % Number of samples

% Create the dataset
[data, truePDF] = generateDataset(noDims, noSamples); 

% Running HMC, select with gradient or stochastic gradient
prob = @likelihood;
gradProb = @gradLikelihood;
%gradProb = @stocGradLikelihood;

% Initializing the options (manually done checking the code in hmc)
options = -1 * ones(18, 1);
options(9) = 0; % false
options(14) = 50000; % Run for 50000 iterations
options(15) = 0; % burn in
options(7) = 10; % Number of leap steps
options(1) = 0; % Display 
options(18) = 0.0001; %step size

% Relatively good prior
priorPDF = struct('lambda', 0.0001);
            
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
                                      data, priorPDF, truePDF, options(18), batchInfo);
    % Selecting the batches at 'random' or in a 'linear' way
    
    mcmcSamples = samples;
end

% Verify samples
generatePlots(data, mcmcSamples, truePDF, priorPDF, initGuess);
%generateTrajectory(data, samples, truePDF);                                                
toc