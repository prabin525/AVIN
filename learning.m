%The main file to implement all the elements of the neural network
%function learning

%Initialize
    %clear; close all; clc;

%the default parametes
    input_layer_size = 400; %20*20 imput image results 400 pixels in total. 
    hidden_layer_size = 25; %25 hidden units
    num_labels = 16;        % from 0-9, BAA, NA,ba,pa, cha, ja
   
%to load the data
    
    %load('train.mat')
    m = size(X,1);

%Random initialization of the weights or theta
    initial_Theta1 = randInitializeWeights (input_layer_size,hidden_layer_size);
    initial_Theta2 = randInitializeWeights (hidden_layer_size,num_labels);
    
    %unroll the theta terms to get a parameters in our desired format
    
    initial_nn_params = [initial_Theta1(:); initial_Theta2(:)];
    
    %training the NN using the advanced optimization equation 
    
    options = optimset('MaxIter',50);
    
    cfunction = @(p) costFunction(p,input_layer_size,hidden_layer_size,num_labels,X,y);
    
    [nn_params, cost] = fmincg(cfunction, initial_nn_params, options);
    
    
    Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1))

    Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1))
 %end            