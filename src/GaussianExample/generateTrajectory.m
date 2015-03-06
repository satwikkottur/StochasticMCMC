function generateTrajectory(data, samplePath, truePDF)
    % Generating some plots of true sampling and posterior sampling

    postMean = (truePDF.mean +  sum(data)) / (size(data, 1) + 1);
    
    fprintf('True mean: (%f %f)\nPost mean: (%f %f)\n', truePDF.mean(1), ...
                                truePDF.mean(2), postMean(1), postMean(2));
    

    % Plotting the MCMC samples and posterior
    figure(1); hold on
        plot(postMean(1), postMean(2), 'o')
        for i = 1:length(samplePath)-1
            plot([samplePath(i, 1) samplePath(i, 2)],...
                        [samplePath(i+1, 1) samplePath(i+1, 2)],...
                        'Color', 'r', 'LineWidth', 1)
        end
    hold off

end

