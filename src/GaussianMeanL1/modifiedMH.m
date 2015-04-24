function accept = modifiedMH(data, curSample, prevSample, curP, ...
                                        prevP, batchSize, threshold, ...
                                        priorPDF)
    % MH modified to use only a batch from the data
    
    % Compute mu0 for the previous and current samples
    noData = size(data, 1);
    
    priorTerm = -0.5 * ((prevSample - priorPDF.mean) * priorPDF.precision ...
                                * (prevSample - priorPDF.mean)' - ...
                        (curSample - priorPDF.mean) * priorPDF.precision ...
                        * (curSample - priorPDF.mean)') ;
    transitionTerm = -0.5 * (prevP^2 - curP^2);
    mu0 = 1/noData * (log(rand()) + priorTerm + transitionTerm);
    
    % Mean values for l and lsquared, along with batch size
    meanL = 0;
    meanL2 = 0;
    curBatchSize = 0;
    
    % Remaining indices for the batches, from the original dataset
    remIndices = 1:noData;
    
    done = false;
    while(~done)
        % Pick a batch
        if(length(remIndices) > batchSize)
            indices = randperm(length(remIndices), batchSize);
        else
            indices = remIndices;
        end
        
        % Overpicking and then selecting the unique
        %indices = randi(noData, [batchSize, 1]);
        curBatchSize = batchSize + curBatchSize;
        batch = data(remIndices(indices), :);

        % Removing the picked batch indices
        remIndices(indices) = [];
        
        % update E[l] and E[l^2]
        % Shifting the batch using previous sample
        pShifted = bsxfun(@minus, batch, prevSample);
        % Shifting the batch using current sample
        cShifted = bsxfun(@minus, batch, curSample);
        l = -0.5 * sum(cShifted .^ 2, 2) + 0.5 * sum(pShifted .^ 2, 2);

        % update E[l] and E[l^2]
        meanL = (meanL * (curBatchSize - batchSize) + ...
                        mean(l) * batchSize)/curBatchSize;
        meanL2 = (meanL2 * (curBatchSize - batchSize) + ...
                        mean(l.^2) * batchSize)/curBatchSize;

        % Compute standard deviation
        sL = sqrt((meanL2 - meanL^2) * batchSize / (batchSize-1));
        s = sL / sqrt(batchSize) * sqrt(1 - (batchSize - 1)/(noData - 1));

        % Check for confidence
        delta = 1 - tcdf(abs((meanL - mu0)/s));

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
end

