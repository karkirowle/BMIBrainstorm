% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 

function modelParameters = trainKalman(modelParameters, trainingData)

angles = size(trainingData,2);
trials = size(trainingData,1);

% Shape the array for least squares estimation

counter = 0;
neuronRegress = zeros(80000,98);
positionOut = zeros(80000,2);
for i=1:angles
    for j=1:10
        tempSpike = spikeFilter(trainingData(j,i).spikes, modelParameters.window, ...,
            modelParameters.std);
        tempPos = diff(trainingData(j,i).handPos);
        for k=1:length(tempSpike)-1
            counter = counter + 1;
            neuronRegress(counter,1:98) = tempSpike(:,k)';
            positionOut(counter,1:2) = tempPos(1:2,k)';
        end
    end
end

neuronRegress(counter+1:end,:) = [];
positionOut(counter+1:end,:) = [];

Mdl = fitrlinear(neuronRegress, positionOut(:,1), 'Regularization', 'lasso');

tempSpike = spikeFilter(trainingData(15,1).spikes, modelParameters.window, ...,
    modelParameters.std);
xposes = predict(Mdl, tempSpike');
xposes2 = cumsum([trainingData(15,1).handPos(1,1); xposes]);

figure;
plot(trainingData(15,1).handPos(1,:));
hold on;
plot(xposes2');

for k=1:8
    posMean = [modelParameters.xAvg{k}; modelParameters.yAvg{k}];
    spikes = modelParameters.spikeAvg{k};
    time = size(posMean,2);
   
    % Kinetic model
    
    % Y = X*A + epsilon
    % Next Position = A*Position + WGN

    
    % Least squares mean
    X = posMean(:,1:time-1);
    Y = posMean(:,2:time);
    
    A = Y * X' * inv(X * X');
    C = cond(X * X');
    
    W = 1/(time-1) .*  ( Y * Y' - (A*X) * Y');
    
    % Neural activity model
    % Y = X' * A + epsilon
    % Y' = A' * X + epsilon
    
    % Y = A*X
    % Next Position = H * Neuron + WGN
    %  98*t  = 98*2 2*t
    % Y = A * X
    X = posMean(:,1:time-1);
    Y = spikes(1:98,1:time-1); % spikes
    
    figure;
    plot(posMean(:,1:time-1).', posMean(:,2:time).')
    % time * time uncertainty
    H = Y * X' * inv(X * X');
    C = cond(X * X');
    
    Q = 1/(time-1) .* ( Y * Y' - (H*X) * Y');
    %Q =  ( Y * Y' - (H*X) * Y');
    
    modelParameters.A{k} = A;
    modelParameters.W{k} = W;
    modelParameters.H{k} = H;
    modelParameters.Q{k} = Q;
end
end