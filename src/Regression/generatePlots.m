function generatePlots(XTest, yTest, samples)
    % Generating some plots of true sampling and posterior sampling

    % Root mean squared error (samples are row vectors)
    RSME = rms(bsxfun(@minus, XTest * samples(:, 1:end-1)', yTest)) ...
                                                ./ sqrt(samples(:, end))';
    
    RSMEMean = rms(yTest - XTest * mean(samples(:, 1:end-1))') ...
                                        / sqrt(mean(samples(:, end)));
                                    
    RSMEMedian = rms(yTest - XTest * median(samples(:, 1:end-1))') ...
                                        / sqrt(median(samples(:, end)));
    
    burnIn = 0;
    skip = 50;
    RSME = RSME(burnIn+1:skip:end);
    % Plotting the RSME for all the samples
    figure; hold all
        plot(RSME)
        plot(RSMEMean * (ones(1, length(RSME))));        
        plot(RSMEMedian * (ones(1, length(RSME))));        
        axis 'tight'
    hold off
    
    figure; 
        sparsity = sum(samples == 0, 2);
        plot(sparsity(1:skip:end))
    
end
