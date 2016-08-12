%This computes the sigmoid function of the input
function g = sigmoid(z)
    g = (1.0 ./ (1.0 + exp(-z)));
end
