function likelihood = likelihood(theta, data, priorPDF, truePDF)
    % Finding the likelihood for the Gaussian case
    % Assuming theta to be the parameter value
    % priorPDF(struct) has mean and variance attributes
    
    % Asserting if theta is a row vector
    assert(isrow(priorPDF.mean));
    assert(isrow(theta));
    
    % Assuming the prior variance to be eye for now
    likelihood = 0.5 * (theta-priorPDF.mean) * (theta-priorPDF.mean)';
    %likelihood = (theta-priorPDF.mean) * inv(priorPDF.variance) * ...
    %                                        (theta-priorPDF.mean)';
    
                                        
    shifted = 0.5 * bsxfun(@minus, data, theta);
    likelihood = likelihood + sum(diag(shifted * shifted'));
    %likelihood = likelihood + ...
    %                sum(diag(shifted * inv(truePDF.variance) * shifted'));
end

