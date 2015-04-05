function gradient = gradLikelihood(theta, y, X, varargin)
    % Function to compute the gradient given the data, current estimate of
    % theta and prior for theta
    
    % Asserting if theta is a row vector
    % assert(isrow(theta));
    
    % Evaluating the gradient
    weighted = sum(bsxfun(@times, X, theta), 2);
    error = y - weighted;
    
    gradient = sum(bsxfun(@times, X, error)); % Plus a prior term
end

