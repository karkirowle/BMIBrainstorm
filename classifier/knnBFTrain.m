% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 

% K nearest neighbour classifier

function modelParameters = knnBFTrain(trainingData,modelParameters)

% Create a vector of spikes and vector of angles
angles = size(trainingData,2);
trials = size(trainingData,1);
numNeurons = size(trainingData(1,1).spikes,1);
timeClip = 320;
timeClip2 = 400;

trainX = zeros(angles*trials,numNeurons*timeClip);
trainX2 = zeros(angles*trials,numNeurons*timeClip2);

modelParameters.training = trainingData;
for i=1:angles
    for j=1:trials
    index = (i-1)*trials + j;
    % Flattening of spike-time dimensions allows KNN training

    flattenNeuron = spikeFilter(trainingData(j,i).spikes(:,1:timeClip),...,
        modelParameters.window,modelParameters.std);
    timeOrderedNeurons = reshape(flattenNeuron, [1, numNeurons*timeClip]);
    trainX(index,:,:) = timeOrderedNeurons;

    flattenNeuron = spikeFilter(trainingData(j,i).spikes(:,1:timeClip2),...,
        modelParameters.window,modelParameters.std);
    timeOrderedNeurons = reshape(flattenNeuron, [1, numNeurons*timeClip2]);
    trainX2(index,:,:) = timeOrderedNeurons;

    end
end

modelParameters.knnx{320} = trainX;
modelParameters.knnx{400} = trainX2;

end