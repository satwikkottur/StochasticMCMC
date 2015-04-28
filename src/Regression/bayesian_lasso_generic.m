function B = bayesian_lasso_generic(X,Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name - bayesian_lasso_generic
% Creation Date - 8th Jan 2014
% Author: Soumya Banerjee
% Website: https://sites.google.com/site/neelsoumya/
%
% Description: 
%   Function to generate test dataset and call generic function to
%   perform Bayesian LASSO
%
% Input:  
%       X - matrix of predictors
%       Y - vector of responses
%       small_sigma_squared - standard deviation^2 (variance) for covariance matrix for Y
%       eta_sqaured - standard deviation^2 (variance) for covariance matrix for beta (regressors)
%
% Output: 
%       1) Matrix of inferred regressors (B)
%
% Assumptions -
%
% Example usage:
%       X = randn(100,5)
%       r = [0;2;0;-3;0] % only two nonzero coefficients
%       Y = X*r + randn(100,1)*.1 % small added noise
%       B = bayesian_lasso_generic(X,Y)
%
% License - BSD 
%
% Acknowledgements -
%           Dedicated to my mother Kalyani Banerjee, my father Tarakeswar Banerjee
%               and my wife Joyeeta Ghose.
%
% Change History - 
%                   8th Jan 2014  - Creation by Soumya Banerjee
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iNum_regressors = size(X,2);
n = size(Y,1); % length of Y
p = size(X,2); % length of beta
%% Bayesian LASSO (Park and Castella 2008)
iNumIter = 1000;

%% Initialize variables
tau = 0.1;
D_tau = diag(repmat(1,1,size(X,2))*tau);
sigma_squared = 0.1;


%% Lambda
lambda = 1.5;

%% Gibbs sampler
for iCount = 1:iNumIter

	%% beta posterior (conditional)

	A = X'*X + inv(D_tau);

	beta_posterior(iCount,:) = [mvnrnd(inv(A)*X'*Y,sigma_squared*inv(A))];
    
	%% sigma_squared
	%% draw from an inverse gamma with 
	%% shape parameter alpha_prime = (n-1)/2 + p/2
	%% scale parameter beta_prime  = (Y - X*beta_posterior)'*(Y - X*beta_posterior) + beta_posterior'*inv(D_tau)*beta_posterior/2
	%% this is equivalent to drawing from the reciprocal of a gamma distribution with 
	%% scale parameter alpha = alpha_prime + 2
	%% shape parameter beta  = 1/beta_prime
	alpha_prime = (n-1)/2 + p/2;
    % use beta_posterior' instead of beta_posterior
	beta_prime  = (Y - X*beta_posterior(iCount,:)')'*(Y - X*beta_posterior(iCount,:)')/2 + beta_posterior(iCount,:)*inv(D_tau)*beta_posterior(iCount,:)'/2;
    
    alpha = alpha_prime;
	beta  = 1/beta_prime;

	sigma_squared = 1./gamrnd(alpha,beta);

	%% 1/tau^2
    tau_squared_vector = [];
	for iCount_regressors = 1:iNum_regressors
        mu_prime     = sqrt(lambda^2*sigma_squared/((beta_posterior(iCount,iCount_regressors)')^2));
        lambda_prime = lambda^2;
        %1/tau_squared(iCount_regressors) <- sample_inverse_gaussian(mu_prime,lambda_prime)
        
        %tau_squared(iCount_regressors) = 1./sample_inverse_gaussian(mu_prime,lambda_prime)
        
        pd = makedist('InverseGaussian','mu',mu_prime,'lambda',lambda_prime);
        tau_squared(iCount_regressors) = 1./random(pd);
        tau_squared_vector = [ tau_squared_vector tau_squared(iCount_regressors) ];
	end

	%% D_tau
    D_tau = diag(tau_squared_vector);
end

%% return posterior
B = beta_posterior;

%% plot histograms
if iNum_regressors == 5
    iNumBins = 100;
    figID = figure;
    subplot(2,3,1)
    hist(beta_posterior(1:end,1),iNumBins)
    hold on
    subplot(2,3,2)
    hist(beta_posterior(1:end,2),iNumBins)
    hold on
    subplot(2,3,3)
    hist(beta_posterior(1:end,3),iNumBins)
    hold on
    subplot(2,3,4)
    hist(beta_posterior(1:end,4),iNumBins)
    hold on
    subplot(2,3,[5 6])
    hist(beta_posterior(1:end,5),iNumBins)

    hold off

    %% save plots
    print(figID, '-djpeg', sprintf('BayesianLASSO_parameters_hist%s.jpg', date));
    
    %% plot Monte Carlo trace plots
    figID_2 = figure;
    plot(beta_posterior(1:end,1))
    xlabel('Monte Carlo samples'); ylabel('Posterior of one regressor parameter')
    print(figID_2, '-djpeg', sprintf('mcmctrace_%s.jpg', date));
end

