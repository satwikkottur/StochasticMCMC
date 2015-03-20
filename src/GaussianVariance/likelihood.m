function likelihood = likelihood(theta, data, meanPrior, varargin)
    % Finding the likelihood for the Gaussian case
    % Assuming theta to be the parameter value
    % meanPrior(struct) has mean and variance attributes
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    % Computing the likelihood
    thetaM = theta(1:end-1);
    thetaV = theta(end);
    
    % Prior on theta
    likelihood = 0.5 * (thetaM - meanPrior.mean) * meanPrior.precision * ...
                        (thetaM - meanPrior.mean)';
    
    % Prior on variance
    likelihood = likelihood - log(thetaV);
    
    shifted = bsxfun(@minus, data, thetaM);
    % Faster computation
    precision = 1/thetaV * eye(length(thetaM));
    product = shifted * precision;
    product = product .* shifted;
    likelihood = likelihood + 0.5 * sum(product(:));
end


