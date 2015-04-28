function generatePlots(XTest, yTest, samples, sigmaYes, sparsityCutOff)
    % Generating some plots of true sampling and posterior sampling
    if (sigmaYes)
        % Root mean squared error (samples are row vectors)
        RSME = sum((bsxfun(@minus, XTest * samples(:, 1:end-1)', yTest)).^2)...
                                                    ./ (samples(:, end))';



        RSMEMean = sum((yTest - XTest * mean(samples(:, 1:end-1))').^2)...
                                            / (mean(samples(:, end)));

        RSMEMedian = sum((yTest - XTest * median(samples(:, 1:end-1))').^2) ...
                                            / (median(samples(:, end)));

                                    
    else
        % Root mean squared error (samples are row vectors)
        RSME = sum((bsxfun(@minus, XTest * samples(:, 1:end-1)', yTest)).^2);



        RSMEMean = sum((yTest - XTest * mean(samples(:, 1:end-1))').^2)

        RSMEMedian = sum((yTest - XTest * median(samples(:, 1:end-1))').^2)
    end
    
    burnIn = 0;
    skip = 10;
    RSME = RSME(burnIn+1:skip:end);
    size(RSME)
    % Plotting the RSME for all the samples
    figure; hold all
        title(sigmaYes)
        plot(RSME)
        %axis 'tight'
    %hold off
    %figure; hold all;
        plot(RSMEMean * (ones(1, length(RSME))));        
        plot(RSMEMedian * (ones(1, length(RSME))));        
    hold off;
    if (sigmaYes)
        figure; 
            sparsity = sum(abs(samples) < sparsityCutOff, 2);
            plot(sparsity(1:skip:end))
            title('Sparsity')
    end
end
