% Default script to be run for test/debugging purposes
close all

% Running the Gaussian example
addpath('GaussianExample/');

noDims = 2; % Number of dimensions
noSamples = 1000; % Number of samples

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
options(14) = 100000; % Run for 1000 iterations
options(15) = 50; % burn in
options(7) = 10; % Number of leap steps
options(1) = 0; % Display 
options(18) = 0.0001;

priorPDF = struct('mean', truePDF.mean + 0.01 * rand(1, noDims), ...%0.5 * ones(1, noDims), ...
                'variance', eye(noDims), ...
                'precision', eye(noDims));

% Generating multiple samples
%noMCMC = 200;
noMCMC = 1;
mcmcSamples = zeros(noMCMC, noDims);
for i = 1:noMCMC
    initGuess = rand(1, noDims);
    [samples, energies, diagn] = hmc(prob, initGuess, options, gradProb, ...
                                                    data, priorPDF, truePDF);
    
    %mcmcSamples(i, :) = samples(end, :);
    %mcmcSamples = samples;
    mcmcSamples = samples(1:100:size(samples, 1), :);
end

% Verify samples
generatePlots2(data, mcmcSamples, truePDF, priorPDF, initGuess);
%generateTrajectory(data, samples, truePDF);                                                
                                                