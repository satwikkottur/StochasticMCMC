noData = size(XTest, 1);

% Script to plot the MSE for various runs
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
    
    %fprintf('MSE for Mean: %d \n', RMSEMean);
    %fprintf('MSE for Median: %d \n', RMSEMedian);
end

%==========================================================================
%fprintf('\n\nLasso\n');

bLasso = lasso(XTrain, yTrain, 'Lambda', lassoLambda);
%fprintf('sparsity %f\n', sum(abs(bLasso) < sparsityCutoff)/length(bLasso))
%generatePlots(XTest, yTest, bLasso)
MSELasso = sum((XTest * bLasso - yTest).^2);
%fprintf('%s = %f\n', 'MSE/sigmaSq', MSE/(trueSigmaSq));
%fprintf('%s = %d\n', 'MSE', MSE);

%==========================================================================
%fprintf('\n\nRigde Regression\n');

bRidge = ridge(yTrain, XTrain, lambdaRidge);
%fprintf('sparsity %f\n', sum(abs(bRidge) < sparsityCutoff)/length(bRidge))
MSERidge = sum((XTest * bRidge - yTest).^2);
%fprintf('%s = %f\n', 'MSE/sigmaSq', MSE/(trueSigmaSq));
%fprintf('%s = %d\n', 'MSE', MSE);
%==========================================================================
burnIn = 0;
skip = 1;
xRange = burnIn+1:skip:length(RMSE);
RMSE = RMSE(xRange);

% Plotting the RSME for all the samples
figure; hold all
    % Plotting MSE for all the samples    
    plot(xRange, RMSE/MSELasso, 'b')
    % Plotting the smaple median
    plot(xRange, RMSEMean/MSELasso * (ones(1, length(RMSE))), '--');        
    % Plotting for sample mean
    plot(xRange, RMSEMedian/MSELasso * (ones(1, length(RMSE))), '--');
    % Plotting ridge
    % plot(MSERidge/MSELasso * (ones(1, length(RMSE))), '-.');
    % Plotting Lasso
    plot(xRange, MSELasso/MSELasso * (ones(1, length(RMSE))), '-.');
    
    % Legend
    legend('Sample MSE', 'Sample Mean MSE', 'Sample Median MSE', ...
           'Lasso', 'FontSize', 30);
    
    % Labellings
    title('Mean Square Error (MSE)', 'FontSize', 18)
    xlabel('Samples', 'FontSize', 18)
    ylabel('MSE', 'FontSize', 18)
    axis 'tight'
hold off;
%==========================================================================