function fisher = getFisherMatrix(distribution)
    % Function that returns the fisher information matrix calculated
    % analytically based on the distribution structure
    % Here, dimensions is the dimensionality of the parameter space and not
    % those of the points
    
    noDims = distribution.dimensions;
    variance = distribution.variance;
    
    I = zeros(noDims, noDims);
    switch distribution.type
        % Multivariate gaussian with mean and single parameter covariance
        case 'mGaussMeanSigma' 
            % Diagonal matrix with last element
            I = diag([1/variance * ones(1, noDims-1), noDims/(2*variance^2)]);
    end
    fisher = I;
end

