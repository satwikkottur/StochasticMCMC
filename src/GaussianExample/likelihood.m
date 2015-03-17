function likelihood = likelihood(theta, data, priorPDF, truePDF)
    % Finding the likelihood for the Gaussian case
    % Assuming theta to be the parameter value
    % priorPDF(struct) has mean and variance attributes
    
    % Asserting if theta is a row vector
    assert(isrow(priorPDF.mean));
    assert(isrow(theta));
    
    % Assuming the prior variance to be eye for now
    %likelihood = 0.5 * (theta-priorPDF.mean) * (theta-priorPDF.mean)';
    %likelihood = (theta-priorPDF.mean) * inv(priorPDF.variance) * ...
    %                                        (theta-priorPDF.mean)';
    likelihood = 0.5 * (theta - priorPDF.mean) * priorPDF.precision * ...
                        (theta - priorPDF.mean)';
                                        
    shifted = bsxfun(@minus, data, theta);
    %likelihood = likelihood + sum(diag(shifted * shifted'));
    %likelihood = likelihood + ...
    %                sum(diag(shifted * inv(truePDF.variance) * shifted'));
    
    %likelihood = likelihood + sum(0.5 * diag(shifted * truePDF.precision * shifted'));
    for i = 1:size(data, 1)
        likelihood = likelihood + 0.5 * shifted(1, :) * truePDF.precision * ...
                                        shifted(1, :)';
    end
end

