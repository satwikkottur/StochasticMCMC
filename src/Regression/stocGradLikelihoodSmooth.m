function gradient = stocGradLikelihood(theta, XBatch, yBatch, lambda, steplength, dataSize)    
% Function to compute the stochastic gradient given the data,
    % current estimate of theta and prior for theta
    %
    % There are two options for selecting the batches:
    % Linear - linearly select the batches
    % Random - Select the batches at random
    d = length(theta) - 1;
    batchSize = length(yBatch);
    
    sigmaSq = theta(end);
    beta = theta(1:end-1)';
    gradient = zeros(size(theta));
    
    % For the batch
    XtX = XBatch' * XBatch;
    Xty = XBatch' * yBatch;

    % Gradient wrt sigmaSq
    residual = yBatch - XBatch * beta;
    gradient(end) = (1 + dataSize/2 + d/2) / sigmaSq - ...
                    (dataSize / batchSize) * dot(residual, residual)/(2*sigmaSq^2)...
                    - lambda * norm(beta, 1) / (2 * sqrt(sigmaSq)^3);
    
    % Gradient wrt beta: function is F+lambda/sqrt(sigmaSq) * norm(beta, 1)
    % REsidual is y - xB
    gradF = (dataSize/ batchSize) * (XtX * beta - Xty) / sigmaSq;  
    
    %smoothing parameter
    smoother = 1e-6;
    
    vec = lambda * beta / (sqrt(sigmaSq) * smoother);
    alpha_star = vec .* (abs(vec) < 1)  + sign(vec) .* (abs(vec) >= 1);
    gradient(1:end-1) = gradF + lambda / sqrt(sigmaSq) * alpha_star;
    
end