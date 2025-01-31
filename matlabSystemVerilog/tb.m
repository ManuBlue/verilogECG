% Testbench for the MLP function
clc;
clear;

% Test case 1: Standard input
input1 = [1, 0.5, -1];
output1 = MLP(input1);
disp('Test Case 1:');
disp('Input:');
disp(input1);
disp('Output:');
disp(output1);

% Test case 2: All zeros
input2 = [0, 0, 0];
output2 = MLP(input2);
disp('Test Case 2:');
disp('Input:');
disp(input2);
disp('Output:');
disp(output2);

% Test case 3: All ones
input3 = [1, 1, 1];
output3 = MLP(input3);
disp('Test Case 3:');
disp('Input:');
disp(input3);
disp('Output:');
disp(output3);

% Test case 4: Negative values
input4 = [-1, -0.5, -2];
output4 = MLP(input4);
disp('Test Case 4:');
disp('Input:');
disp(input4);
disp('Output:');
disp(output4);

% Test case 5: Mixed values
input5 = [2, -1, 0.5];
output5 = MLP(input5);
disp('Test Case 5:');
disp('Input:');
disp(input5);
disp('Output:');
disp(output5);
