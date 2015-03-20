function gradient = gradLikelihood(theta, data, priorPDF, truePDF, varargin)
    % Function to compute the gradient given the data, current estimate of
    % theta and prior for theta
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    % Evaluating the gradient
    shifted = bsxfun(@minus, data, theta);
    gradient = (theta - priorPDF.mean) * priorPDF.precision; 
    gradient = gradient + sum(shifted * truePDF.precision);
end

