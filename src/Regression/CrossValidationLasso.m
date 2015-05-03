%% Running the inbuilt MATLAB Lasso
fprintf('\n\nLasso\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambdaRange = 10.^(-10:10);
mse = zeros(size(lambdaRange));
sparsity = zeros(size(lambdaRange));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(lambdaRange)    
    bLasso = lasso(XTrain, yTrain, 'Lambda', lambdaRange(i));
    %fprintf('sparsity %f\n', sum(abs(bLasso) < sparsityCutoff)/length(bLasso))
    %generatePlots(XTest, yTest, bLasso)
    mse(i) = sum((XTest * bLasso - yTest).^2);
    sparsity(i) = sum(abs(bLasso) < 1e-10) / length(bLasso);
    %fprintf('%s = %f\n', 'MSE/sigmaSq', MSE/(trueSigmaSq));
    fprintf('%s (%d) = %d\n', 'MSE', i, mse(i));
end

figure; plot(sparsity)
figure; plot(mse)

%%
fprintf('\n\nRigde Regression\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambdaRange = 10.^(-10:10);
mse = zeros(size(lambdaRange));
sparsity = zeros(size(lambdaRange));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(lambdaRange)
    bRidge = ridge(yTrain, XTrain, lambdaRange(i));
    %fprintf('sparsity %f\n', sum(abs(bRidge) < sparsityCutoff)/length(bRidge))
    mse(i) = sum((XTest * bRidge - yTest).^2);
    sparsity(i) = sum(abs(bRidge) < 1e-10) / length(bRidge);
    %fprintf('%s = %f\n', 'MSE/sigmaSq', MSE/(trueSigmaSq));
    %fprintf('%s = %d\n', 'MSE', MSE);
    fprintf('%s (%d) = %d\n', 'MSE', i, mse(i));
end
figure; plot(sparsity)
figure; plot(mse)

%%
% Using 3rd party bayesian lasso package
% otherB = bayesian_lasso_generic(XTrain, yTrain);
% 
% % Computing the errors
% generatePlots(XTest, yTest, otherB, sigmaYes, sparsityCutoff);