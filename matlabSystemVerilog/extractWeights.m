% Load parameters
params = load("D:\Projects\verilogECG\matlabSystemVerilog\params_2025_01_26__10_16_14.mat");

% Extract weights and biases and convert to regular arrays
% Ensure proper handling of deep learning arrays using gather or extractdata
W1 = gather(extractdata(params.aten__linear0.Layer.Param_weight)); % Convert Layer 1 weights
b1 = gather(extractdata(params.aten__linear0.Layer.Param_bias));   % Convert Layer 1 biases

W2 = gather(extractdata(params.aten__linear3.Layer.Param_weight)); % Convert Layer 2 weights
b2 = gather(extractdata(params.aten__linear3.Layer.Param_bias));   % Convert Layer 2 biases

W3 = gather(extractdata(params.aten__linear6.Layer.Param_weight)); % Convert Layer 3 weights
b3 = gather(extractdata(params.aten__linear6.Layer.Param_bias));   % Convert Layer 3 biases

% Save as normal MATLAB arrays
save('converted_params.mat', 'W1', 'b1', 'W2', 'b2', 'W3', 'b3');
