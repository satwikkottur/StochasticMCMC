%% Running the inbuilt MATLAB Lasso
fprintf('\n\nLasso\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lassoLambda = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bLasso = lasso(XTrain, yTrain, 'Lambda', lassoLambda);
fprintf('sparsity %f\n', sum(abs(bLasso) < sparsityCutoff)/length(bLasso))
%generatePlots(XTest, yTest, bLasso)
MSE = sum((XTest * bLasso - yTest).^2);
%fprintf('%s = %f\n', 'MSE/sigmaSq', MSE/(trueSigmaSq));
fprintf('%s = %d\n', 'MSE', MSE);

%%
fprintf('\n\nRigde Regression\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lambdaRidge = 0.00001;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bRidge = ridge(yTrain, XTrain, lambdaRidge);
fprintf('sparsity %f\n', sum(abs(bRidge) < sparsityCutoff)/length(bRidge))
MSE = sum((XTest * bRidge - yTest).^2);
%fprintf('%s = %f\n', 'MSE/sigmaSq', MSE/(trueSigmaSq));
fprintf('%s = %d\n', 'MSE', MSE);
%%
% Using 3rd party bayesian lasso package
% otherB = bayesian_lasso_generic(XTrain, yTrain);
% 
% % Computing the errors
% generatePlots(XTest, yTest, otherB, sigmaYes, sparsityCutoff);