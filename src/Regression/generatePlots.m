function generatePlots(XTest, yTest, samples)
    % Generating some plots of true sampling and posterior sampling

    % Root mean squared error (samples are row vectors)
    RSME = rms(bsxfun(@minus, XTest * samples(:, 1:end-1)', yTest)) ...
                                                ./ sqrt(samples(:, end))';
    
    RSMEMean = rms(yTest - XTest * mean(samples(:, 1:end-1))') ...
                                        / sqrt(mean(samples(:, end)));
                                    
    RSMEMedian = rms(yTest - XTest * median(samples(:, 1:end-1))') ...
                                        / sqrt(median(samples(:, end)));
    
    burnIn = 10000;
    skip = 100;
    RSME = RSME(burnIn:skip:end);
    % Plotting the RSME for all the samples
    figure; hold all
        plot(RSME)
        plot(RSMEMean * (ones(1, length(RSME))));        
        plot(RSMEMedian * (ones(1, length(RSME))));        
        axis 'tight'
    hold off
end
