function gradient = gradLikelihood(theta, X, y, XtX, Xty, lambda, steplength)
    % Function to compute the gradient given the data, current estimate of
    % theta and prior for theta
    
    % Asserting if theta is a row vector
    %assert(isrow(theta));
    
    d = length(theta) - 1;
    n = length(y);
    
    sigmaSq = theta(end);
    beta = theta(1:end-1)';
    
    gradient = zeros(size(theta));
    
    % Gradient wrt sigmaSq
    residual = y - X * beta;
    gradient(end) = (1 + n/2 + d/2) / sigmaSq - dot(residual, residual)/(2*sigmaSq^2)...
                        - lambda * norm(beta, 1) / (2 * sqrt(sigmaSq)^3);
    
    % Gradient wrt beta 
    % REsidual is y - xB
    gradF = (XtX * beta - Xty) / sigmaSq;  
    
    % Proximal gradient (after taking step wrt f)
    newBeta = beta - steplength * gradF;
    constant = steplength * lambda / sqrt(sigmaSq);
    
    % Computing the proximal gradient
    proxBeta = (newBeta < -constant) .* (newBeta + constant) + ...
                (newBeta > constant) .* (newBeta - constant);
    
    gradient(1:end-1) = (beta - proxBeta) / steplength;
end