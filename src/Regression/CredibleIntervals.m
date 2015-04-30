alpha = 0.05; 
lower = quantile(samples, alpha/2);
upper = quantile(samples, 1-alpha/2);

lower_fail_lasso = sum(lower > bLasso');
upper_fail_lasso = sum(upper < bLasso');
fail_lasso = sum( (lower > bLasso') | (upper < bLasso'));


lower_fail_ridge = sum(lower > bRidge');
upper_fail_ridge = sum(uppwe < bRidge');
fail_ridge = sum( (lower > bRidge') | (upper < bRidge'));

fprintf('%%%%%%%%%%%%\nCREDIBLE INTERVAL ANALYSIS:\n');
fprintf('Dimensions: %d\n', length(bRidge));
fprintf('Lasso Violators: %d\n', fail_Lasso);
fprintf('Ridge Violators: %d\n', fail_Ridge);