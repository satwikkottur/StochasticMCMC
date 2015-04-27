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
    
    % Gradient wrt beta 
    % REsidual is y - xB
    gradF = (dataSize/ batchSize) * (XtX * beta - Xty) / sigmaSq;  
    
    % Proximal gradient (after taking step wrt f)
    newBeta = beta - steplength * gradF;
    constant = steplength * lambda / sqrt(sigmaSq);
    
    % Computing the proximal gradient
    proxBeta = (newBeta < -constant) .* (newBeta + constant) + ...
                (newBeta > constant) .* (newBeta - constant);
    
    gradient(1:end-1) = (beta - proxBeta) / steplength;
end