function gradient = gradLikelihood(theta, data, priorPDF, stepSize, varargs)
    % Function to compute the gradient given the data, current estimate of
    % theta and prior for theta
    
    % Asserting if theta is a row vector
    %assert(isrow(theta));
    
    % Evaluating the gradient
    shifted = bsxfun(@minus, data, theta);
    gradient_p = theta; %(theta - priorPDF.mean) * priorPDF.precision; 
    gradient_L =  sum(shifted);
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
