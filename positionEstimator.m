% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 


function [x, y, P] = positionEstimator(test_data, P)

spikeLength = size(test_data.spikes,2);

if (spikeLength == 320 || spikeLength == 400)
    neurons = test_data.spikes(:,1:spikeLength);
    flattenNeuron = spikeFilter(neurons, ...,
        P.window,P.std);
    
    % Classify using the neareast mean spiking
    if (spikeLength == 320)
        comparison = zeros(1,8);
        for i=1:8
            comparison(i) = immse(squeeze(P.avgSpike(i,:,:)),flattenNeuron);
        end
        [~,I] = min(comparison);
        P.angle = I(1);
        
        flattenNeuron320 = reshape(flattenNeuron, [1, 98*spikeLength]);
        % Classify using the NN
        
        if (P.trainNN)
            [~, outcome] = max(P.classifierNet(flattenNeuron320'));
            P.angle = outcome;
        end
        
        % Classify using SVM
        if (P.svmTrain)
            P.angle = predict(P.svm, flattenNeuron320);
        end
    end
    
    % Find path with KNN
    if (P.trainKNN)
        flattenNeuron = reshape(flattenNeuron, [1, 98*spikeLength]);
        P.which = knnsearch(P.knnx{spikeLength},flattenNeuron);
        
        % Convert indices
        i = ceil(P.which(1) / P.trainSize);
        j = P.which - (i-1)*P.trainSize;
        P.fullX = P.training(j,i).handPos(1,:);
        P.fullY = P.training(j,i).handPos(2,:);
    end
end

% Position estimate retrieval
if (P.kalmanOn)
    flattenNeuron = spikeFilter(test_data.spikes, ...,
        P.window,P.std);
    [x,y, P] = kalmanFilter(flattenNeuron, P, test_data);
else
    if (P.stdSelection)
        [x,y] = knnStdBased(P,spikeLength);
    else
        if (P.estimateLMS)
            [x,y,P] = estimateLMS(test_data,P);
        else
            if (P.populationVector)
                [x,y,P] = pvrEstimator(test_data,P);
            else
                [x,y] = knnSingleTuning(P,spikeLength);
            end
        end
    end
end


end