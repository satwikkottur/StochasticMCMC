function likelihood = likelihood(theta, y, X, varargin)
    % Finding the likelihood for the Gaussian case
    % Assuming theta to be the parameter value
    % priorPDF(struct) has mean and variance attributes
    
    % Asserting if theta is a row vector
    %assert(isrow(theta));
    
    % Computing the likelihood
    weighted = sum(bsxfun(@times, X, theta), 2);
    error = bsxfun(@minus, weighted, y);
    
    % Faster computation
    likelihood = sum(error .^ 2); % Plus a prior term
end


