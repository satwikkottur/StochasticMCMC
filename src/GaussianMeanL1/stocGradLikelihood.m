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
            batch = data(randi(batchInfo.size, [1 size(data, 1)]), :);
            
        case 2
            % Need to figure out what is to be done here %
            batch = data(1:batchInfo.size, :);
    end
    
    % Evaluating the gradient
    shifted = bsxfun(@minus, batch, theta);
    %gradient_p = (theta - priorPDF.mean) * priorPDF.precision; 
    gradient_L = size(data, 1)/batchInfo.size * sum(shifted * truePDF.precision); %scale liklihood term
    gradient = gradient_mapping_l1(theta, gradient_L, priorPDF.lambda, stepsize);
    %gradient = gradient_p + gradient_L;
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

