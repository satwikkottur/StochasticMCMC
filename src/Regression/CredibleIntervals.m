alpha = 0.05; 
lower = quantile(samples, alpha/2);
upper = quantile(samples, 1-alpha/2);

lower_fail_lasso = sum(lower(1:end-1) > bLasso');
upper_fail_lasso = sum(upper(1:end-1) < bLasso');
fail_lasso = sum( (lower(1:end-1) > bLasso') | (upper(1:end-1) < bLasso'));


lower_fail_ridge = sum(lower(1:end-1) > bRidge');
upper_fail_ridge = sum(upper(1:end-1) < bRidge');
fail_ridge = sum( (lower(1:end-1) > bRidge') | (upper(1:end-1) < bRidge'));

fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\nCREDIBLE INTERVAL ANALYSIS:\n');
fprintf('Dimensions: %d\n', length(bRidge));
fprintf('Lasso Violators: %d\n', fail_lasso);
fprintf('Ridge Violators: %d\n', fail_ridge);
% lower_fail_lasso
% upper_fail_lasso
% lower_fail_ridge
% upper_fail_ridge
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');