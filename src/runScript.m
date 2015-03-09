% Default script to be run for test/debugging purposes
close all

% Running the Gaussian example
addpath('GaussianExample/');

noDims = 2; % Number of dimensions
noSamples = 100; % Number of samples

% Create the dataset
[data, truePDF] = generateDataset(noDims, noSamples); 

% Running HMC
prob = @likelihood;
gradProb = @gradLikelihood;

% Running hmc
%[samples, energies, diagn] = hmc(f, x, options, gradf, varargin);

% Initializing the options (manually done checking the code in hmc)
options = -1 * ones(18, 1);
options(9) = 0; % false

priorPDF = struct('mean', 0.5 * ones(1, noDims), ...
                'variance', eye(noDims), ...
                'precision', eye(noDims));

% Generating multiple samples
noMCMC = 100;
mcmcSamples = zeros(noMCMC, noDims);
for i = 1:noMCMC
    initGuess = rand(1, noDims);
    [samples, energies, diagn] = hmc(prob, initGuess, options, gradProb, ...
                                                    data, priorPDF, truePDF);
    
    mcmcSamples(i, :) = samples(end, :);
end

% Verify samples
generatePlots(data, mcmcSamples, truePDF, priorPDF);
%generateTrajectory(data, samples, truePDF);                                                
                                                