function generatePlots(data, mcmcSamples, truePDF, priorPDF, initGuess)
    % Generating some plots of true sampling and posterior sampling

    % Plotting the true samples
    figure(1); hold all
        plot(data(:, 1), data(:, 2), 'x')
        % True mean
        plot(truePDF.mean(1), truePDF.mean(2), 'o');
    hold off

    %%%%%%%%%%%%%%%%%%% Checking the mean %%%%%%%%%%%%%%%%%%%
    noData = size(data, 1);
    postMean = (priorPDF.precision + noData * truePDF.precision) \ ...
                (priorPDF.precision * priorPDF.mean' +  ...
                    truePDF.precision * sum(data)');
    mle = mean(data)';
    
    fprintf('True mean: (%f %f)\n', truePDF.mean(1), truePDF.mean(2));
    fprintf('Post mean: (%f %f)\n', postMean(1), postMean(2));
    fprintf('MLE mean : (%f %f)\n', mle(1), mle(2));
    %%%%%%%%%%%%%%%%%%% Checking the variance %%%%%%%%%%%%%%%%%%%
    postVariance = inv(priorPDF.precision + noData * truePDF.precision);
    fprintf('Post variance = \n'); disp(postVariance)
    
    shifted = bsxfun(@minus, data, mean(data));
    sampleVariance = 1/noData * (shifted' * shifted);
    fprintf('Sample variance = \n'); disp(sampleVariance)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plotting the MCMC samples and posterior
    figure(2); hold all
        plot(mcmcSamples(:, 1), mcmcSamples(:, 2), 'x')
        plot(postMean(1), postMean(2), 'o')
        plot(mle(1), mle(2), '*');
        plot(initGuess(1), initGuess(2), 's')
    hold off

end

