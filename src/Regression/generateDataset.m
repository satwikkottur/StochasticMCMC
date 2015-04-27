function [X, y, beta, sigmaSq] = generateDataset(noDims, noSamples)
    % Function to generate toy dataset
    % Samples are taken from a normal pdf, for regression
    %
    % Usage
    % [X, y, beta, sigmaSq] = generateDataset(noDims, noSamples)
    
    beta = rand(noDims, 1);
    sigmaSq = rand(1);
    
    % X is taken from multivariate Gaussian with zero mean and I covariance
    X = mvnrnd(zeros(noDims, 1), ones(1, noDims), noSamples);
    
    % Generating y from normal with mean (xTy)
    y = X * beta + normrnd(0, sigmaSq); 
end

