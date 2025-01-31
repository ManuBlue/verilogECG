function output = MLP(input)
    % Simulate a single layer in a multilayer perceptron
    % input: a 1x3 array representing previous layer activations
    % output: a 1x4 array of activations for the current layer

    % Hardcoded weights (3x4 matrix)
    weights = [
        0.2, 0.4, 0.6, 0.8;
        0.1, 0.3, 0.5, 0.7;
        -0.2, -0.4, -0.6, -0.8
    ];

    % Hardcoded biases (1x4 array)
    biases = [0.1, -0.1, 0.2, -0.2];

    % Validate input dimensions
%    if size(input, 2) ~= 3
 %       error('Input must be a 1x3 array.');
  %  end

    % Calculate the output of the layer
    output = input * weights + biases;
end
