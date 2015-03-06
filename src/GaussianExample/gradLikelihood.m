function gradient = gradLikelihood(theta, data, priorPDF, truePDF)
    % Function to compute the gradient given the data, current estimate of
    % theta and prior for theta
    
    % Asserting if theta is a row vector
    assert(isrow(theta));
    
    % Evaluating the gradient
    %gradient = sum((inv(truePDF.variance) * bsxfun(@minus, data, theta)), 1) ...
    %                            - inv(priorPDF.variance) * (theta - priorPDF.mean);    
    gradient = sum(bsxfun(@minus, data, theta), 1) ...
                                - (theta - priorPDF.mean);    
end

