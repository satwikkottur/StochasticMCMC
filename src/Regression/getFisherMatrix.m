function fisher = getFisherMatrix(distribution)
    % Function that returns the fisher information matrix calculated
    % analytically based on the distribution structure
    % Here, dimensions is the dimensionality of the parameter space and not
    % those of the points
    %
    % Returns the vector, to be treated as a diagonal matrix
    
    noParam = distribution.dimensions;
    variance = distribution.variance;
    
    I = zeros(noParam, noParam);
    switch distribution.type
        % Multivariate gaussian with mean and single parameter covariance
        case 'mGaussMeanSigma' 
            % Diagonal matrix with last element
            I = [1/variance * ones(1, noParam-1), (noParam-1)/(2*variance^2)];
            
        case 'mGaussMean'
            I = 1/variance * ones(1, noParam);
            
        case 'BayessianLasso'
            I = [];
    end
    fisher = I;
end

