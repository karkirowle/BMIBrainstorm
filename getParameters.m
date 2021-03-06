% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 

function modelParameters = getParameters

    % TESTING GUIDE FOR DIFFERENT ALGORITHMS
    
    % ---------------------- CLASSIFIER -----------------------------------
    % Average spiking heuristic - trainKinetic = true, meanDifference= true
    % SVM - svmTrain = true
    % SVMTemplate has to be modified explicitly to switch to RBF kernel
    
    % ---------------------- REGRESSOR ------------------------------------
    % Standard deviation based KNN-mean trade off - stdSelection = true
    % Least mean square - estimateLMS, trainLMS = true
    % Population vector - populationVector = true
    % If everything is turned off the mean estimator is used
    % testFunction_for_students_MTb('brainstorm',1)
    % The second argument is the tuning parameter lambda
    
    
    modelParameters.P = 1;
    
    % Gaussian filter
    modelParameters.window = 500;
    modelParameters.std = 100;
    
    % Kalman Filter setup - not really useful
    modelParameters.kalmanOn = false;
    
    % Neural network setup
    modelParameters.trainNN = false;

    % Part of the mean-difference setup
    modelParameters.trainKinetic = true;
    modelParameters.meanDifference = true;
    modelParameters.trainKNN = true;
    
    % Regression
    modelParameters.stdSelection = false;
    modelParameters.trainLMS = false;
    modelParameters.estimateLMS = false;
    modelParameters.populationVector = false;
    
    % Tunable parameters/settings
    modelParameters.last = false;
    modelParameters.knnThreshold = 5;
    
    % SVM classifier
    modelParameters.svmTrain = true;
    modelParameters.svmTemplate = ...,
        templateSVM('Standardize',1, ...,
        'KernelFunction','linear');
end