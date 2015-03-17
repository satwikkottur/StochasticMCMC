function gradient = gradLikelihood(theta, data, priorPDF, truePDF)
    % Function to compute the gradient given the data, current estimate of
    % theta and prior for theta
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    % Evaluating the gradient
    %gradient = sum((inv(truePDF.variance) * bsxfun(@minus, data, theta)), 1) ...
    %                            - inv(priorPDF.variance) * (theta - priorPDF.mean);    
    %gradient = sum(truePDF.precision * bsxfun(@minus, data, theta)', 2)' ...
    %                        - (priorPDF.precision * (theta - priorPDF.mean)')';    
    
    shifted = bsxfun(@minus, data, theta);
    gradient = (theta - priorPDF.mean) * priorPDF.precision; 
    gradient = gradient + sum(shifted * truePDF.precision);
end

