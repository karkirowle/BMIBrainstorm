function [Xpos, Ypos,trainparam]= pvrEstimator(testing_data, trainparam)

instant_firing_rate=zeros(98,1);

spikeLength = size(testing_data.spikes,2);
if (spikeLength == 320)
    Xpos=testing_data.startHandPos(1,1);
    Ypos=testing_data.startHandPos(2,1);
else
    Xpos = trainparam.previousX;
    Ypos = trainparam.previousY;
end
for neuron=1:98
    instant_firing_rate(neuron,1) = sum(testing_data.spikes(neuron,(length(testing_data.spikes)-20):length(testing_data.spikes)))/20;
    
    
    %Xpos=Xpos+ 2*(instant_firing_rate(neuron,1)/trainparam.maximum_firing_rate(neuron))*...
    %((trainparam.x_vector_direction(trainparam.preferred_direction(neuron),length(testing_data.spikes)))-...
    %(trainparam.x_vector_direction(trainparam.preferred_direction(neuron),(length(testing_data.spikes)-20))))/98;
    
    diff=inf;
    for degree=1:360
        if (trainparam.firing_rate_curve(degree,neuron)-instant_firing_rate(neuron,1))<diff
            diff=trainparam.firing_rate_curve(degree,neuron)-instant_firing_rate(neuron,1);
            direction_angle(neuron)=degree;
        end
    end
    
    %%Ypos=Ypos+ 2*(instant_firing_rate(neuron,1)/trainparam.maximum_firing_rate(neuron))*...
    %  ((trainparam.y_vector_direction(trainparam.preferred_direction(neuron),length(testing_data.spikes)))-...
    % (trainparam.y_vector_direction(trainparam.preferred_direction(neuron),(length(testing_data.spikes)-20))))/98;
    
    %Xpos=Xpos+ *(instant_firing_rate(neuron,1)/trainparam.maximum_firing_rate(neuron))*...
    %((trainparam.x_vector_direction(trainparam.preferred_direction(neuron),length(testing_data.spikes)))-...
    %(trainparam.x_vector_direction(trainparam.preferred_direction(neuron),(length(testing_data.spikes)-20))))/98;
end
final_direction=deg2rad(mean(direction_angle));

Xpos=Xpos+ cos(final_direction)*trainparam.vec_mean;
Ypos=Ypos+ sin(final_direction)*trainparam.vec_mean;

trainparam.previousX = Xpos;
trainparam.previousY = Ypos;

end