function gradient = stocGradLikelihood(theta, data, priorPDF, truePDF, batchInfo)
    % Function to compute the stochastic gradient given the data,
    % current estimate of theta and prior for theta
    %
    % There are two options for selecting the batches:
    % Linear - linearly select the batches
    % Random - Select the batches at random
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    switch batchInfo.select
        case 1
            %batch = data(randperm(size(data, 1), batchInfo.size), :);
            batch = data(randi(size(data, 1), [1 batchInfo.size]), :);
            
        case 2
            % Need to figure out what is to be done here %
            batch = data(1:batchInfo.size, :);
    end
    
    % Evaluating the gradient, after picking up the batch
    shifted = bsxfun(@minus, batch, theta);
    gradient = (theta - priorPDF.mean) * priorPDF.precision; 
    gradient = gradient + ...
            size(data, 1)/batchInfo.size * sum(shifted * truePDF.precision);
end

