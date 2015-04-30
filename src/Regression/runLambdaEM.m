function [lambda] = runLambdaEM(initLambda, XVal, yVal)
    % Running the EM algorithm for lambda estimation

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Setting up HMC
    
    % Values
    noDims = size(XVal, 2);
    
    stochastic = false;
    prob = @likelihood;
    if (stochastic)
        gradProb = @stocGradLikelihood;
    else
        gradProb = @gradLikelihood;
    end

    % Initializing the options (manually done checking the code in hmc)
    options = -1 * ones(18, 1);
    options(9) = 0; % false
    options(14) = 5000; % Run for 50000 iterations
    options(15) = 500; % burn in
    options(7) = 50; % Number of leap steps
    options(1) = 0; % Display 
    options(18) = 1e-4; %step size

    % Infomation for selecting the batches
    batchSize = 30;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generating the fisher matrix
    % Use mle mean and mle variance
    % mleMean = mean(data);
    % shifted = bsxfun(@minus, data, mleMean);
    % mleVar = 1/size(data, 1) * sum(sum(shifted .* shifted));
    % 
    % gaussian = struct('type', 'mGaussMean', 'variance', mleVar, ...
    %                 'dimensions', noDims);

    %gaussian = struct('type', 'mGaussMeanSigma', 'variance', mleVar, ...
    %    'dimensions', noDims+1);
    %fisher = getFisherMatrix(gaussian);
    fisher = zeros(1, noDims+1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Number of EM iteration
    noIters = 50; % Max of 100 iterations
    
    lambda = initLambda;
    initGuess = rand(1, noDims + 1);
    
    for i = 1:noIters
        prevLambda = lambda;
        % Running HMC, select with gradient or stochastic gradient
        % Stochastic
        if (stochastic)
            [samples, ~] = shmc(prob, initGuess, options, gradProb, ...
                                XVal, yVal, lambda, batchSize, fisher, []);
        else
            [samples, ~] = hmc(prob, initGuess, options, gradProb, ...
                                XVal, yVal, lambda, []);    
        end

        % Estimate the value of lambda empirically
        sampleL1 = sum(abs(samples(:, 1:end-1)), 2);
        lambda = noDims / mean(sampleL1 ./ sqrt(samples(:, end)));
        
        fprintf('\n====================\nNew lambda : %f\n\n', lambda);
        % Setting up the initial point
        initGuess = samples(end, :);
        
        % Convergence test (break)
        if(abs(prevLambda - lambda) < 1e-2)
            break
        end
    end
end

