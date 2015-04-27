function [X, y, beta, sigmaSq] = generateDataset(noDims, noSamples)
    % Function to generate toy dataset
    % Samples are taken from a normal pdf, for regression
    %
    % Usage
    % [X, y, beta, sigmaSq] = generateDataset(noDims, noSamples)
    
    beta = randn(noDims, 1);
    sigmaSq = rand(1);
    
    % X is taken from multivariate Gaussian with zero mean and I covariance
    %X = mvnrnd(zeros(noDims, 1), ones(1, noDims), noSamples);
    
    % Making few entries of X zeros
    fraction = 0.01;
    rows = randi(noSamples, [noSamples * noDims * fraction, 1]);
    cols = randi(noDims, [noSamples * noDims * fraction, 1]);
    vals = randn(noSamples * noDims * fraction, 1);
    X = sparse(rows, cols, vals);
    
    % Generating y from normal with mean (xTy)
    y = X * beta + normrnd(0, sigmaSq); 
end

