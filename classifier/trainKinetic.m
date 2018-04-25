% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 

function modelParameters = trainKinetic(trainTrial, modelParameters)
% Output:
    % xavg - x position averages in struct
    % yavg - y position averages in struct
    % modelParameters - if there is an already existing model parameters struct
% Input:
    %  trainTrial - training examples

% Parameters
trialNumber = size(trainTrial,1);
angles = size(trainTrial,2);
neuronNumber = 98;
maxTime = 1000;

for k=1:angles
    averagePosX = NaN(trialNumber, maxTime);
    averagePosY = NaN(trialNumber, maxTime);
    averageSpike = NaN(trialNumber, neuronNumber, maxTime);
    for i=1:trialNumber
        actLength = length(trainTrial(i,k).handPos(1,:));
        averagePosX(i,1:actLength) = trainTrial(i,k).handPos(1,:);
        averagePosY(i,1:actLength) = trainTrial(i,k).handPos(2,:);
        averageSpike(i,1:98,1:actLength) = ...,
            trainTrial(i,k).spikes;
    end
    
    % Take NanStd 
    stdPosX = nanstd(averagePosX);
    stdPosY = nanstd(averagePosY);
    % Take NanMeans of known values, which gives NaN for zero samples
    averagePosX = nanmean(averagePosX);
    averagePosY = nanmean(averagePosY);

    
    % If there is a NaN, use last position OR 0
    if(modelParameters.last)
        averagePosX(isnan(averagePosX))=averagePosX(find(~isnan(averagePosX),1, 'last'));
        averagePosY(isnan(averagePosY))= averagePosY(find(~isnan(averagePosY),1, 'last'));
    else
        averagePosX(isnan(averagePosX))=0;
        averagePosY(isnan(averagePosY))=0;
    end
    
    
    % Spike -> set to zero
    averageSpike = squeeze(nanmean(averageSpike));
    averageSpike(isnan(averageSpike)) = 0;
    modelParameters.xAvg{k} = averagePosX;
    modelParameters.yAvg{k} = averagePosY;
    modelParameters.xStd{k} = stdPosX;
    modelParameters.yStd{k} = stdPosY;
    modelParameters.spikeAvg{k} = averageSpike;


end

end
