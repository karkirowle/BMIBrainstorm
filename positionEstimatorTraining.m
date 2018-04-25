% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 


function [modelParameters] = positionEstimatorTraining(training_data)

tic;

% Parameters
modelParameters = getParameters;
modelParameters.trainSize = size(training_data,1);



if (modelParameters.trainNN)
    modelParameters = trainClassifierNN(training_data, modelParameters);
end

if (modelParameters.svmTrain)
    modelParameters = svmTrain(training_data, modelParameters);
end

if (modelParameters.trainKinetic)
    modelParameters = trainKinetic(training_data, modelParameters);
end
if(modelParameters.kalmanOn)
   modelParameters = trainKalman(modelParameters, training_data);
end

if (modelParameters.meanDifference)
    modelParameters = trainMeanDifference(training_data,modelParameters);
end

if (modelParameters.trainKNN)
    modelParameters = knnBFTrain(training_data, modelParameters);
end
if (modelParameters.trainLMS)
   modelParameters = trainLMS(training_data, modelParameters); 
end
if (modelParameters.populationVector)
    modelParameters = pvrTraining(training_data, modelParameters);
end
disp("Total time of training:");

toc;


end