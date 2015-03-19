function likelihood = likelihood(theta, data, priorPDF, truePDF, varargin)
    % Finding the likelihood for the Gaussian case
    % Assuming theta to be the parameter value
    % priorPDF(struct) has mean and variance attributes
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    % Computing the likelihood
    likelihood = 0.5 * (theta - priorPDF.mean) * priorPDF.precision * ...
                        (theta - priorPDF.mean)';
                                        
    shifted = bsxfun(@minus, data, theta);
    
    % Faster computation
    product = shifted * truePDF.precision;
    product = product .* shifted;
    likelihood = likelihood + 0.5 * sum(product(:));
end


