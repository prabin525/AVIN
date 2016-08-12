%This is the cost function which return the cost and the gradients term.

function [J grad] = costFunction(nn_params,input_layer_size,hidden_layer_size,num_labels,X,y)

    Theta1 = reshape(nn_params(1: hidden_layer_size *(input_layer_size+1)),hidden_layer_size,(input_layer_size+1));
    
    Theta2 = reshape(nn_params((1+(hidden_layer_size*(input_layer_size +1))):end),num_labels, (hidden_layer_size+1));

    m = size(X,1);
    
    
    
    J = 0; %The Cost
    Theta1_grad = zeros(size(Theta1)); %Gradient of the theta1
    Theta2_grad = zeros(size(Theta2)); %Gradient of the Theta2
    
    %feedforward segment
    a1 = [ones(m,1) X];
    z2 = a1* Theta1';
    a2 = sigmoid(z2);
    a2 = [ones(m,1) a2];
    z3 = a2*Theta2';
    htheta = sigmoid(z3);
    
    %calculation of the cost
    for k = 1: num_labels
        yk = y==k;
        hthetak = htheta(:,k);
        jk = 1 / m *sum(-yk .* log(hthetak) - (1-yk) .* log(1-hthetak));
        J = J+jk;
    end
    
    %calculation of the delta
    for t = 1:m
        for k = 1:num_labels
            yk = y(t) == k;
            delta_3(k) = htheta(t,k)-yk;
        end
        
        delta_2 = Theta2' * delta_3' .* sigmoidGradient([1,z2(t,:)])';
        delta_2 = delta_2(2:end);
        
         Theta1_grad = Theta1_grad + delta_2 * a1(t, :);
        Theta2_grad = Theta2_grad + delta_3' * a2(t, :);
    end
    
    Theta1_grad = Theta1_grad / m;
    Theta2_grad = Theta2_grad / m;
%now to unroll gradients

    grad = [Theta1_grad(:) ; Theta2_grad(:)];

end