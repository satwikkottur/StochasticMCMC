% Running the inbuilt MATLAB Lasso
bLasso = lasso(XTrain, yTrain, 'Lambda', 0.000001);
fprintf('sparsity %f\n', sum(abs(bLasso) < sparsityCutoff)/length(bLasso))
%generatePlots(XTest, yTest, bLasso)
MSE = sum((XTest * bLasso - yTest).^2);
MSE
fprintf('%s = %f\n', 'MSE/sigmaSq', MSE/(trueSigmaSq));

lambdaRidge = 0.00001;
bRidge = ridge(yTrain, XTrain, lambdaRidge);
fprintf('sparsity %f\n', sum(abs(bRidge) < sparsityCutoff)/length(bRidge))
MSE = sum((XTest * bRidge - yTest).^2);
MSE
fprintf('%s = %f\n', 'MSE/sigmaSq', MSE/(trueSigmaSq));

% Using 3rd party bayesian lasso package
otherB = bayes_lasso_generic(XTrain, yTrain);

% Computing the errors
generatePlots(XTest, yTest, otherB, sigmaYes, sparsityCutoff);