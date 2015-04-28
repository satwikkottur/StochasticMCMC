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
    
    %smoothing parameter
    smoother = 1e-6;
    
    vec = lambda * beta / (sqrt(sigmaSq) * smoother);
    alpha_star = vec .* (abs(vec) < 1)  + sign(vec) .* (abs(vec) >= 1);
    gradient(1:end-1) = gradF + lambda / sqrt(sigmaSq) * alpha_star;
end