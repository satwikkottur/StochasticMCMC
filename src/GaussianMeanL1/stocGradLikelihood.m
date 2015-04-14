function gradient = stocGradLikelihood(theta, data, priorPDF, stepSize, batchSize, varargs)
    % Function to compute the stochastic gradient given the data,
    % current estimate of theta and prior for theta
    %
    % There are two options for selecting the batches:
    % Linear - linearly select the batches
    % Random - Select the batches at random
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    batch = data(randi( size(data, 1), [batchSize, 1]), :);
    % Evaluating the gradient
    shifted = bsxfun(@minus, batch, theta);
    gradient_p = (theta); 
    gradient_L = size(data, 1)/batchSize * sum(shifted); %scale liklihood term
    %gradient = gradient_mapping_l1(theta, gradient_L, priorPDF.lambda, stepSize);
    gradient = gradient_p + gradient_L;
end

function g = gradient_mapping_l1(point, grad1, lambda, stepsize)
    p = prox_l1(point - stepsize * grad1, lambda * stepsize);
    g = (point - p) / stepsize;
end

function p = prox_l1(points, lambda)
    i = points < -lambda;
    j = points > lambda;
    %k = abs(points) < lambda;
    p = zeros(size(points));
    p(i) = points(i) + lambda;
    p(j) = points(j) - lambda;
end

