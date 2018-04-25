function modelParameters = trainMeanDifference(trainingData, modelParameters)

% Parameters
angles = size(trainingData,2);
trials = size(trainingData,1);
numNeurons = size(trainingData(1,1).spikes,1);
timeClip = 320;

% Preallocation
trainX = zeros(angles,trials,numNeurons,timeClip);

for i=1:angles
    for j=1:trials
        trainX(i,j,:,:) = spikeFilter(trainingData(j,i).spikes(:,1:timeClip),modelParameters.window,modelParameters.std);
    end
end

% Average for each angle

modelParameters.avgSpike = squeeze(mean(trainX,2));

end