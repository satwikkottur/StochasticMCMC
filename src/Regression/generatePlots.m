function generatePlots(XTest, yTest, samples, sigmaYes, sparsityCutOff)
    % Generating some plots of true sampling and posterior sampling
    if (sigmaYes)
        % Root mean squared error (samples are row vectors)
        RMSE = sum((bsxfun(@minus, XTest * samples(:, 1:end-1)', yTest)).^2)...
                                                    ./ (samples(:, end))';



        RMSEMean = sum((yTest - XTest * mean(samples(:, 1:end-1))').^2)...
                                            / (mean(samples(:, end)));

        RMSEMedian = sum((yTest - XTest * median(samples(:, 1:end-1))').^2) ...
                                            / (median(samples(:, end)));

                                    
    else
        % Root mean squared error (samples are row vectors)
        RMSE = sum((bsxfun(@minus, XTest * samples(:, 1:end-1)', yTest)).^2);



        RMSEMean = sum((yTest - XTest * mean(samples(:, 1:end-1))').^2);

        RMSEMedian = sum((yTest - XTest * median(samples(:, 1:end-1))').^2);
        fprintf('MSE for Mean: %d \n', RMSEMean);
        fprintf('MSE for Median: %d \n', RMSEMedian);
    end
    
    burnIn = 0;
    skip = 10;
    RMSE = RMSE(burnIn+1:skip:end);
    % Plotting the RSME for all the samples
    figure; hold all
        title(sigmaYes)
        plot(RMSE)
        plot(RMSEMean * (ones(1, length(RMSE))));        
        plot(RMSEMedian * (ones(1, length(RMSE))));        
    hold off;
%     if (sigmaYes)
%         figure; 
%             sparsity = sum(abs(samples) < sparsityCutOff, 2);
%             plot(sparsity(1:skip:end))
%             title('Sparsity')
%     end
end
