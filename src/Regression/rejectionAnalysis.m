% checking if there are rejections, based on the consecutive values
sampleDiff = samples(1:end-1, :) - samples(2:end, :);
rejections = abs(sum(abs(sampleDiff), 2) - 0) < 1e-8;
fprintf('Rejection ratio : %f\n', sum(rejections)/size(samples, 1));
%figure; plot(cumsum(rejections))

%hist(rejections)
%plot(rejections)
%size(samples)