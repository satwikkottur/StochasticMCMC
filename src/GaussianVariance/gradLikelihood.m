function gradient = gradLikelihood(theta, data, meanPrior, varargin)
    % Function to compute the gradient given the data, current estimate of
    % theta and prior for theta
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    % Evaluating the gradient
    thetaM = theta(1:end-1);
    thetaV = theta(end);
    precision = 1/thetaV * eye(length(thetaM));
    
    shifted = bsxfun(@minus, data, thetaM);
    
    % Gradient wrt mean
    gradient = zeros(1, length(theta));
    gradient(1:end-1) = (thetaM - meanPrior.mean) * meanPrior.precision; 
    gradient(1:end-1) = gradient(1:end-1) + sum(shifted * precision);
    
    % Gradient wrt sigma
    gradient(end) = (-0.5/thetaV^2) * norm(shifted, 'fro')^2 - 1/thetaV;
end

