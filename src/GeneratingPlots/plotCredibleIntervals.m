% Script to plot the credible intervals for dimensions
% dims = 1:10;
% 
% % Assumes : lower, upper, bLasso, bRidge, sampleMedian
% lower = rand(10, 1);
% upper = lower + rand(10, 1);
% bLasso = rand(10, 1);
% bRidge = rand(10, 1);
% sampleMedian = rand(10, 1);

% Lower and upper quantiles
%alpha = 0.05; 
%lower = quantile(samples, alpha/2);
%upper = quantile(samples, 1-alpha/2);% Upper

lowerPt = lower(dims)';
upperPt = upper(dims)';
lassoPt = bLasso(dims);
ridgePt = bRidge(dims);
samplePt = sampleMedian(dims);
range = (1:length(dims))';


% Begin plotting
figure; hold on
    % Credible interval
    h1 = plot([lowerPt, upperPt]', [range, range]', 'b-');
    % Extremes
    h2 = plot([lowerPt, upperPt], [range, range], 'bx');
    % Sample median
    h3 = plot(samplePt, [range, range], 'ro', 'LineWidth', 2);
    % Lasso
    h4 = plot(lassoPt, [range, range], 'gs');
    % Ridge 
    h5 = plot(ridgePt, [range, range], 'k*');

    % Labellings
    title('Credible Intervals', 'FontSize', 18)
    xlabel('Values', 'FontSize', 18)
    ylabel('Dimension', 'FontSize', 18)
    
    % Legend
    legend([h1(1) h2(1) h3(1) h4(1) h5(1)], ...
            {'Credible Interval', 'Credible points', ...
            'Sample median', ...
            'Lasso', ...
            'Ridge'}, 'FontSize', 14)
hold off