function likelihood = likelihood(theta, X, y, lambda)
    % Finding the likelihood for the Gaussian case
    % Assuming theta to be the parameter value
    % priorPDF(struct) has mean and variance attributes
    
    % Asserting if theta is a row vector
    %assert(isrow(theta));
    
    % Computing the likelihood
    d = length(theta) - 1;
    n = length(y);
    
    sigmaSq = theta(end);
    beta = theta(1:end-1)';
    residual = y - X * beta;
    
    likelihood = (1 + n/2 + d/2) * log(sigmaSq) + ...
                            dot(residual, residual)/(2 * sigmaSq) + ...
                            lambda / sqrt(sigmaSq) * norm(beta, 1);
end


