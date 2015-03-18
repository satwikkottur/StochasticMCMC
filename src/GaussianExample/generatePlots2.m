function generatePlots2(data, mcmcSamples, truePDF, priorPDF, initGuess)
    % Generating some plots of true sampling and posterior sampling

    % Plotting the true samples
    figure(1); hold all
        plot(data(:, 1), data(:, 2), 'x')
        % True mean
        plot(truePDF.mean(1), truePDF.mean(2), 'o');
    hold off

    noData = size(data, 1);
    postMean = (priorPDF.precision + noData * truePDF.precision) \ ...
                (priorPDF.precision * priorPDF.mean' +  ...
                    truePDF.precision * sum(data)');
    mle = mean(data)';
    (priorPDF.precision + noData * truePDF.precision) \ ...
                (priorPDF.precision * priorPDF.mean' +  ...
                    truePDF.precision * sum(data)');
    
    %postMean = (truePDF.mean +  sum(data)) / (size(data, 1) + 1);
    
    fprintf('True mean: (%f %f)\nPost mean: (%f %f)\n', truePDF.mean(1), ...
                                truePDF.mean(2), postMean(1), postMean(2));
    fprintf('mle: (%f %f)\n', mle);
    % Plotting the MCMC samples and posterior
    figure(2); hold all
        plot(mcmcSamples(:, 1), mcmcSamples(:, 2), 'x')
        plot(postMean(1), postMean(2), 'o')
        plot(mle(1), mle(2), '*');
        plot(initGuess(1), initGuess(2), 's')
    hold off

end

