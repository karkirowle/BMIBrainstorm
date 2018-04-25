% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018


function param = pvrTraining(training_data, param)

%%Calculate Firing Rate (in Hz), along with maximum rate for each neuron
%%and their prefered direction of spiking

firing_rate=zeros(98,8);
for direction=1:8
    for neuron=1:98
        for trialnumber=1:length(training_data)
            firing_rate(neuron,direction)= firing_rate(neuron,direction)+(sum(training_data(trialnumber,direction).spikes(neuron,:))/length(training_data(trialnumber,direction).spikes));
        end
        firing_rate(neuron,direction)=(firing_rate(neuron,direction)/length(training_data));
        [param.maximum_firing_rate(neuron) param.preferred_direction(neuron)]=max(firing_rate(neuron,:));
    end
end

angles=[30 70 110 150 190 230 310 350];
for neuron=1:98
    firing_rate_curve_total{neuron}=fit(angles(:),transpose(firing_rate(neuron,:)),'cubicinterp');
    for angle=1:360
        param.firing_rate_curve(angle,neuron)= firing_rate_curve_total{neuron}(angle);
    end
end

%finding average direction vector for each direction:
maxTime = 1000;
%averagePosX = NaN(trialNumber, maxTime);
%averagePosY = NaN(trialNumber, maxTime);
xAvg=zeros(8,1000);
yAvg=zeros(8,1000);

for direction=1:8
    averagePosX = NaN(length(training_data), maxTime);
    averagePosY = NaN(length(training_data), maxTime);
    for i=1:length(training_data)
        actLength = length(training_data(i,direction).handPos(1,:));
        averagePosX(i,1:actLength) = training_data(i,direction).handPos(1,:);
        averagePosY(i,1:actLength) = training_data(i,direction).handPos(2,:);
    end
    % Take means of known values, if there are no values for some
    % timesteps, assign 0
    averagePosX = nanmean(averagePosX);
    averagePosX(isnan(averagePosX))=0;
    averagePosY = nanmean(averagePosY);
    averagePosY(isnan(averagePosY))=0;
    x_vector_direction(direction,:) = averagePosX;
    y_vector_direction(direction,:) = averagePosY;
end

% Calculating average movement vector for 20 ms interval
x_vector_disp=zeros(8,50);
y_vector_disp=zeros(8,50);
for direction=1:8
    count=1;
    for time=300:20:length(xAvg(direction,:))
        if  x_vector_direction(direction,time)==0 || x_vector_direction(direction,time+20)==0 || y_vector_direction(direction,time)==0 || y_vector_direction(direction,time+20)==0
            break
        else
            x_vector_disp(direction,count)= x_vector_direction(direction,time+20)-x_vector_direction(direction,time);
            y_vector_disp(direction,count)= y_vector_direction(direction,time+20)-y_vector_direction(direction,time);
            count=count+1;
        end
    end
end

%Calculating Average Movement Vector for 20ms:
for direction=1:8
    count=0;
    for i=1:length(x_vector_disp(direction,:))
        if x_vector_disp(direction,i)==0
            count=count+1;
        end
    end
    param.x_vector_direction(direction,1)=(sum(x_vector_disp(direction,:)))/(length(x_vector_disp(direction,:))-count);
    param.y_vector_direction(direction,1)=(sum(y_vector_disp(direction,:)))/(length(y_vector_disp(direction,:))-count);
    vector_distance(direction)=sqrt(param.x_vector_direction(direction,1)^2+ param.y_vector_direction(direction,1)^2);
end

param.x_vec=mean(param.x_vector_direction);
param.y_vec=mean(param.y_vector_direction);
param.vec_mean=mean(vector_distance);
end