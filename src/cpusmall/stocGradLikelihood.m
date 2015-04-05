function gradient = stocGradLikelihood(theta, y, X, batchInfo)
    % Function to compute the stochastic gradient given the data,
    % current estimate of theta and prior for theta
    %
    % There are two options for selecting the batches:
    % Linear - linearly select the batches
    % Random - Select the batches at random
    
    % Asserting if theta is a row vector
    %assert(isrow(theta));
    
    switch batchInfo.select
        case 1
            batch = randi(size(data, 1), [1 batchInfo.size]);
            XBatch = X(batch, :);
            yBatch = y(batch, :);
            
        case 2
            % Need to figure out what is to be done here %
            batch = randi(size(data, 1), [1 batchInfo.size]);
            XBatch = X(batch, :);
            yBatch = y(batch, :);
    end
    
    % Evaluating the gradient, after picking up the batch
    weighted = sum(bsxfun(@times, XBatch, theta), 2);
    error = yBatch - weighted;
    
    gradient = sum(bsxfun(@times, XBatch, error)); % Plus a prior term
end

