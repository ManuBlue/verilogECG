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
