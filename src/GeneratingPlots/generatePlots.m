% Generate all the plots required for the slides / report

clearvars; % Clear all the variables
rootPath = '/Users/skottur/CMU/Sem2/graphicalModels/MATfiles/';

dataPath = '/Users/skottur/CMU/Sem2/graphicalModels/Datasets/year';
addpath('/Users/skottur/CMU/Sem2/graphicalModels/liblinear-1.96/matlab/');

[yTrain, XTrain] = libsvmread(fullfile(dataPath, 'trainStand.txt'));
[yTest, XTest] = libsvmread(fullfile(dataPath, 'testStand.txt'));
%[yVal, XVal] = libsvmread(fullfile(dataPath, 'valStand.txt'));

%load(fullfile(rootPath, 'prox_stoc_cpu.mat'));
%load(fullfile(rootPath, 'prox_stoc_syn.mat'));
load(fullfile(rootPath, 'subsamples_year.mat'));

samples = samples1;
%load(fullfile(rootPath, 'smooth_stoc_cpu.mat'));
%load(fullfile(rootPath, 'smooth_stoc_syn.mat'));
%load(fullfile(rootPath, 'smooth_stoc_syn.mat'));
%load(fullfile(rootPath, 'smooth_stoc_syn.mat'));
%load(fullfile(rootPath, 'smooth_stoc_syn.mat'));
%load(fullfile(rootPath, 'smooth_stoc_syn.mat'));
%load(fullfile(rootPath, 'smooth_stoc_syn.mat'));
% Year prediction
lassoLambda = 10;
lambdaRidge = 1e5;
sparsityCutoff = 1e-6;

run ../Regression/Lasso.m
%%%%%%%%%%%%%%%%%%%%%%%%% Credible Intervals %%%%%%%%%%%%%%%%%%%%%%%%%%%
sampleMedian = median(samples, 1);
% Choose which dimensions to plot credible intervals for
alpha = 0.05; 
lower = quantile(samples, alpha/2);
upper = quantile(samples, 1-alpha/2);

%dims = 1:length(bLasso);
agree = (lower < 0) & (upper > 0);
range = 1:length(bLasso)+1;

% dims = [range(agree), range(~agree)];

in = range(agree); out = range(~agree);
inRand = in(randperm(length(in), 10)); 
outRand = out(randperm(length(out), 2));

dims = [inRand, outRand];
dims = dims(randperm(length(dims)));
%plotCredibleIntervals;

%%%%%%%%%%%%%%%%%%%%%%%%% MSE %%%%%%%%%%%%%%%%%%%%%%%%%%%
sigmaYes = false;
% lambdaRidge = 10000;
% lassoLambda = 10;

% Year prediction
%lassoLambda = 10;
%lambdaRange = 1e5;

plotMSE;