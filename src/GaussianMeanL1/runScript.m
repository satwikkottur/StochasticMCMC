% Default script to be run for test/debugging purposes
%close all
display('Running Bayesian Lasso');
tic;
stochastic = 1;

noDims = 1; % Number of dimensions
noSamples = 10000; % Number of samples

% Create the dataset
[data, truePDF] = generateDataset(noDims, noSamples); 

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

% Relatively good prior
priorPDF = struct('lambda', 0.1, 'mean', rand(1, noDims));
            
% Generating multiple samples
noMCMC = 1;
mcmcSamples = zeros(noMCMC, noDims);

% Infomation for selecting the batches
batchSize = 30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generating the fisher matrix
% Use mle mean and mle variance
mleMean = mean(data);
shifted = bsxfun(@minus, data, mleMean);
mleVar = 1/size(data, 1) * sum(sum(shifted .* shifted));

gaussian = struct('type', 'mGaussMean', 'variance', mleVar, ...
                'dimensions', noDims);
% gaussian = struct('type', 'mGaussMeanSigma', 'variance', mleVar, ...
%     'dimensions', noDims+1);
fisher = getFisherMatrix(gaussian);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:noMCMC
    initGuess = rand(1, noDims);
    %initGuess = truePDF.mean;
    
    % Stochastic
    if (stochastic)
        [samples, energies, diagn] = shmc(prob, initGuess, options, gradProb, ...
                                    data, priorPDF, batchSize, fisher, []);
    else
        [samples, energies, diagn] = hmc(prob, initGuess, options, gradProb, ...
                                     data, priorPDF, []);    
    end
    
    mcmcSamples = samples;
end

% Verify samples
generatePlots(data, mcmcSamples(1:100:end,:), truePDF, priorPDF, initGuess);
rejectionAnalysis
%generateTrajectory(data, samples, truePDF);                                                
toc