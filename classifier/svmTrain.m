% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 


% SVM classifier

function modelParameters = svmTrain(trainingData,modelParameters)

angles = size(trainingData,2);
trials = size(trainingData,1);
numNeurons = size(trainingData(1,1).spikes,1);
timeClip = 320;
trainX = zeros(angles*trials,numNeurons*timeClip);
trainY = zeros(1, angles*trials);

for i=1:angles
    for j=1:trials
        index = (i-1)*trials + j;
        % Flattening of spike-time dimensions allows KNN training
        tempSpike = spikeFilter(trainingData(j,i).spikes(:,1:timeClip),...,
            modelParameters.window, modelParameters.std);
        timeOrderedNeurons = reshape(tempSpike, ...,
            [1, numNeurons*timeClip]);
        trainX(index,:,:) = timeOrderedNeurons;
        trainY(index) = i;
    end
end


modelParameters.svm = fitcecoc(trainX,trainY,'Learners',modelParameters.svmTemplate);

end