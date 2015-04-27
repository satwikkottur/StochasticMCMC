% Running the inbuilt MATLAB Lasso
bLasso = lasso(XTrain, yTrain, 'Lambda', 0.000001);
sum(bLasso == 0)/length(bLasso)
%generatePlots(XTest, yTest, bLasso)
RSME = rms(bsxfun(@minus, XTest * bLasso, yTest));
RSME/sqrt(trueSigmaSq)