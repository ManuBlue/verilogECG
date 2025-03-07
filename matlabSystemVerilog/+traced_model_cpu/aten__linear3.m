classdef aten__linear3 < nnet.layer.Layer & nnet.layer.Formattable & ...
        nnet.layer.AutogeneratedFromPyTorch & nnet.layer.Acceleratable
    %aten__linear3 Auto-generated custom layer
    % Auto-generated by MATLAB on 26-Jan-2025 10:15:29
    
    properties (Learnable)
        % Networks (type dlnetwork)
        
    end
    
    properties
        % Non-Trainable Parameters
        
        
        
        
    end
    
    properties (Learnable)
        % Trainable Parameters
        Param_weight
        Param_bias
    end
    
    methods
        function obj = aten__linear3(Name, Type, InputNames, OutputNames)
            obj.Name = Name;
            obj.Type = Type;
            obj.NumInputs = 1;
            obj.NumOutputs = 1;
            obj.InputNames = InputNames;
            obj.OutputNames = OutputNames;
        end
        
        function [linear_input_1] = predict(obj,linear_argument1_1)
            
            %Use the input format inferred by the importer to permute the input into reverse-PyTorch dimension order
            [linear_argument1_1, linear_argument1_1_format] = traced_model_cpu.ops.permuteToReversePyTorch(linear_argument1_1, '', 2);
            [linear_argument1_1] = struct('value', linear_argument1_1, 'rank', int64(2));
            
            [linear_input_1] = tracedPyTorchFunction(obj,linear_argument1_1,false,"predict");
            
            
            %Permute U-labelled output to forward PyTorch dimension ordering
            if(any(dims(linear_input_1.value) == 'U'))
                linear_input_1 = permute(linear_input_1.value, fliplr(1:max(2,linear_input_1.rank)));
            end
            
        end
        
        
        
        function [linear_input_1] = forward(obj,linear_argument1_1)
            
            %Use the input format inferred by the importer to permute the input into reverse-PyTorch dimension order
            [linear_argument1_1, linear_argument1_1_format] = traced_model_cpu.ops.permuteToReversePyTorch(linear_argument1_1, '', 2);
            [linear_argument1_1] = struct('value', linear_argument1_1, 'rank', int64(2));
            
            [linear_input_1] = tracedPyTorchFunction(obj,linear_argument1_1,true,"forward");
            
            
            %Permute U-labelled output to forward PyTorch dimension ordering
            if(any(dims(linear_input_1.value) == 'U'))
                linear_input_1 = permute(linear_input_1.value, fliplr(1:max(2,linear_input_1.rank)));
            end
            
        end
        
        
        
        function [linear_input_1] = tracedPyTorchFunction(obj,linear_argument1_1,isForward,predict)
            
            linear_weight_1 = obj.Param_weight;
            
            [linear_weight_1] = struct('value', dlarray(linear_weight_1,'UU'), 'rank', 2);
            
            linear_bias_1 = obj.Param_bias;
            
            [linear_bias_1] = struct('value', dlarray(linear_bias_1,'UU'), 'rank', 1);
            
            [linear_input_1] = traced_model_cpu.ops.pyLinear(linear_argument1_1, linear_weight_1, linear_bias_1);
        end
        
    end
end

