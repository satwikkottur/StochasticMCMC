% Default script to be run for test/debugging purposes
close all
tic;
% Running the Gaussian example
%path = 'GaussianMeanL1/';
%path = 'GaussianMean/';
path = 'GaussianVariance/';
addpath(path);

% Runing the runScript from particular folder
runScript

% Removing the path
rmpath(path);
