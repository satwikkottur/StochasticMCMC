% Script to plot the credible intervals for dimensions
dims = 1:10;

% Assumes : lower, upper, bLasso, bRidge, sampleMedian
lower = rand(10, 1);
upper = lower + rand(10, 1);
bLasso = rand(10, 1);
bRidge = rand(10, 1);
sampleMedian = rand(10, 1);

lowerPt = lower(dims);
upperPt = upper(dims);
lassoPt = bLasso(dims);
ridgePt = bRidge(dims);
samplePt = sampleMedian(dims);

% Begin plotting
figure; hold on
    % Credible interval
    plot([lowerPt, upperPt]', [(1:10)', (1:10)']', 'b-')
    % Extremes
    plot([lowerPt, upperPt], [(1:10)', (1:10)'], 'bx')
    % Sample median
    plot(samplePt, [(1:10)', (1:10)'], 'ro')
    % Lasso
    plot(lassoPt, [(1:10)', (1:10)'], 'gs')
    % Ridge 
    plot(ridgePt, [(1:10)', (1:10)'], 'r*')

    % Labellings

    % Legend
hold off
    