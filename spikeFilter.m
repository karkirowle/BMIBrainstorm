% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 

function filteredSpike = spikeFilter(spikes, std, windowSize)
   filteredSpike = zeros(size(spikes));
    numNeuron = size(spikes,1);
        alfa = (windowSize-1)/(2*std);
  
    for n = 1:numNeuron
          
        temp = conv(spikes(n,:),gausswin(windowSize,alfa)/(std*sqrt(2*pi)));
     
        filteredSpike(n,:) = temp((windowSize)/2:end-(windowSize)/2);
    end
end