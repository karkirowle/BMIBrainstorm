% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 

function modelParameters = trainClassifierNN(trainingData, modelParameters)

% Parameters
angles = size(trainingData,2);
trials = size(trainingData,1);
numNeurons = size(trainingData(1,1).spikes,1);
timeClip = 320;

% Preallocation
trainX = zeros(trials*angles,numNeurons*timeClip);
trainY = zeros(trials*angles, angles);
for i=1:angles
    for j=1:trials
        trainX((angles-1)*trials +j,:,:) = reshape( ...,
            spikeFilter(trainingData(j,i).spikes(:,1:timeClip), ...,
            modelParameters.window,modelParameters.std), [1 numNeurons*timeClip]);
        trainY((angles-1)*trials + j, angles) = 1;
    end
end

% Average for each angle
net = patternnet([10,10]);
% Randomise 
idx = randperm(20*8);
trainX = trainX(idx,:);
trainY = trainY(idx,:);

% Do train this
[net,~] = train(net,trainX',trainY');

modelParameters.classifierNet = net;

end