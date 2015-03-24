function gradient = stocGradLikelihood(theta, data, meanPrior, batchInfo)
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
            batch = data(randi(batchInfo.size, [1 size(data, 1)]), :);
            
        case 2
            % Need to figure out what is to be done here %
            batch = data(1:batchInfo.size, :);
    end
    
    % Evaluating the gradient
    thetaM = theta(1:end-1);
    thetaV = theta(end);
    precision = 1/thetaV * eye(length(thetaM));
    
    shifted = bsxfun(@minus, batch, thetaM);
    
    % Gradient wrt mean
    gradient = zeros(1, length(theta));
    gradient(1:end-1) = (thetaM - meanPrior.mean) * meanPrior.precision; 
    gradient(1:end-1) = gradient(1:end-1) + ...
                size(data, 1)/batchInfo.size * sum(shifted * precision);
    
    % Gradient wrt sigma
    gradient(end) = (-0.5/thetaV^2) * size(data, 1)/batchInfo.size * ...
                                        norm(shifted, 'fro')^2 - 1/thetaV;
end

