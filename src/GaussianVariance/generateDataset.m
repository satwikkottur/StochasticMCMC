function [data, truePDF] = generateDataset(noDims, noSamples)
    % Function to generate toy dataset
    % Samples are taken from a normal pdf (with a normal prior)
    %
    % The posterior must be normal too, which will be verified using HMC
    % Usage
    % data = generateDataset(noDims, noSamples)
    
    % Random mean (parameter, for now)
    % Unit variance (fixed) (storing just the diagonals)
    trueMean = rand(1, noDims);
    trueVar = rand(1);
    truePDF = struct('mean', trueMean, 'variance', trueVar * eye(noDims), ...
                       'precision', 1/trueVar * eye(noDims)); 
    
    data = mvnrnd(truePDF.mean, truePDF.variance, noSamples);
end

