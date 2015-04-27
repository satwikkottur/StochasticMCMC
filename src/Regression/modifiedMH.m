function [accept, entireBatch] = modifiedMH(X, y, nextSample, curSample, ...
                                        nextP, curP, lambda)

    % MH modified to use only a batch from the data
    
    % Debugging message
    %fprintf('Entered modified MH\n');
    
    % Compute mu0 for the previous and current samples
    d = length(curSample) - 1;
    n = length(y);
    
    cSigmaSq = curSample(end); 
    nSigmaSq = nextSample(end);
    cBeta = curSample(1:end-1)';
    nBeta = nextSample(1:end-1)';
    
    % Prior term
    priorTerm = (1 + d/2) * log (nSigmaSq / cSigmaSq) + ...
                    lambda * (norm(nBeta, 1) / sqrt(nSigmaSq) - ...
                                    norm(cBeta, 1) / sqrt(cSigmaSq)) ;
    
    % Transition term
    transitionTerm = -0.5 * (curP * curP' - nextP * nextP');
    
    mu0 = 1/n * (log(rand()) + priorTerm + transitionTerm);
    
    % Mean values for l and lsquared, along with batch size
    meanL = 0;
    meanL2 = 0;
    curBatchSize = 0;
    
    % Remaining indices for the batches, from the original dataset
    remIndices = 1:n;
    
    done = false;
    accept = false;
    
    while(~done)
        % Pick a batch
        if(length(remIndices) > batchSize)
            indices = randperm(length(remIndices), batchSize);
        elseif isempty(remIndices)
            indices = 1:length(remIndices);
        else
            accept = false;
            entireBatch = 1;
            %fprintf('Entire batch used for MH\n');
            return
            %error('Entire data used for MH test');
        end
        
        % Overpicking and then selecting the unique
        %indices = randi(noData, [batchSize, 1]);
        curBatchSize = batchSize + curBatchSize;
        
        XBatch = X(remIndices(indices), :);
        yBatch = y(remIndices(indices), :);

        % Removing the picked batch indices
        remIndices(indices) = [];
        
        % update E[l] and E[l^2]
        cResidual = yBatch - XBatch * cBeta;
        nResidual = yBatch - YBatch * nBeta;
        
        l = 1/2 * (log(cSigmaSq) - log(nSigmaSq)) + ...
                1/2 * ( cResidual.^2 / cSigmaSq - nResidual.^2 / nSigmaSq);

        % update E[l] and E[l^2]
        meanL = (meanL * (curBatchSize - batchSize) + ...
                        sum(l))/curBatchSize;
        meanL2 = (meanL2 * (curBatchSize - batchSize) + ...
                        sum(l.^2))/curBatchSize;

        % Compute standard deviation
        sL = sqrt((meanL2 - meanL^2) * batchSize / (batchSize-1));
        s = sL / sqrt(batchSize) * sqrt(1 - (batchSize - 1)/(n - 1));

        % Check for confidence
        delta = 1 - tcdf(abs((meanL - mu0)/s), curBatchSize-1);

        % We are sure about the decision, decide and exit
        if(delta < threshold)
            % Accept
            if(meanL > mu0)
                accept = true; 
            else
                % Reject
                accept = false;
            end
            done = true;
        end
    end
    
    entireBatch = 0;
    %fprintf('************************ Modified MH successful\n');
    % Debugging message
%     if(curBatchSize ~= 30)
%        fprintf('Modified MH (%d) used : %d / %d \n', accept, curBatchSize, noData);
%     end
end