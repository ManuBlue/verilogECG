import torch
import numpy as np
import torch.nn as nn

# Function to save model weights to a text file in Python list format with high precision (31/32 digits)
def save_weights_to_text(model, file_path, precision=31):
    with open(file_path, "w") as f:
        for name, param in model.named_parameters():
            if param.requires_grad:
                f.write(f"Layer: {name}\n")
                f.write(f"Shape: {param.shape}\n")
                f.write(f"Values:\n")
                
                # Convert tensor to numpy array
                param_values = param.data.cpu().numpy()

                # Format the values with the specified precision, keeping the shape intact
                formatted_values = np.vectorize(lambda x: f"{x:.{precision}f}")(param_values)
                
                # Write the formatted values in the original shape
                f.write(str(formatted_values.tolist()) + "\n")
                f.write("=" * 50 + "\n")

# Define the model architecture

class myModel(nn.Module):
    def __init__(self, input_size, num_classes):
        super(myModel, self).__init__()
        self.model = nn.Sequential(
            nn.Linear(input_size, 128),  # First dense layer
            nn.ReLU(),                  # Activation function
            nn.Dropout(0.2),            # Dropout for regularization
            nn.Linear(128, 64),         # Second dense layer
            nn.ReLU(),                  # Activation function
            nn.Dropout(0.2),            # Dropout for regularization
            nn.Linear(64, num_classes)  # Output layer for classification
        )

    def forward(self, x):
        return self.model(x)

# class myModel(nn.Module):
#     def __init__(self, input_size, num_classes):
#         super(myModel, self).__init__()
#         self.model = nn.Sequential(
#             nn.Linear(input_size, 32),  # First dense layer
#             #nn.ReLU(),                  # Activation function
#             nn.Dropout(0.2),            # Dropout for regularization
#             #nn.Linear(128, 64),         # Second dense layer
#             #nn.ReLU(),                  # Activation function
#             #nn.Dropout(0.2),            # Dropout for regularization
#             nn.Linear(32, num_classes)  # Output layer for classification
#         )

#     def forward(self, x):
#         return self.model(x)


input_size = 187  
num_classes = 5  
model = myModel(input_size, num_classes)

# Load the saved state dictionary into the model
state_dict = torch.load("myModel.pth")
model.load_state_dict(state_dict)

# Save the model weights to a text file
save_weights_to_text(model, "model_weights.txt", precision=31)
