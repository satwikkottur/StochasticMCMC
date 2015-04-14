function likelihood = likelihood(theta, data, priorPDF, varargs)
    % Finding the likelihood for the Gaussian case
    % Assuming theta to be the parameter value
    % priorPDF(struct) has mean and variance attributes
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    % Computing the likelihood
    %likelihood = 0.5 * (theta - priorPDF.mean) * priorPDF.precision * ...
    %                    (theta - priorPDF.mean)';
    
    likelihood = priorPDF.lambda * norm(theta, 1);
    
    shifted = bsxfun(@minus, data, theta);
    
    % Faster computation
    product = shifted;
    product = product .* shifted;
    likelihood = likelihood + 0.5 * sum(product(:));
end


