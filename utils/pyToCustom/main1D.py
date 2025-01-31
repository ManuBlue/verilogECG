import os

scriptDir = os.path.dirname(os.path.abspath(__file__))

# Paths to the input and output files, relative to the script's location
inputFilePath = os.path.join(scriptDir, "input.txt")
outputFilePath = os.path.join(scriptDir, "output.txt")

# Function to convert Python list to SystemVerilog array format
def pyToSV(x):
    xStr = "'{" + ",".join(map(str, x)) + "}"
    return xStr

# Function to scale and convert 1D Python array to SystemVerilog format
def oneDToSv(temp):
    scale_factor = 10**16
    # Convert strings to float, scale, then to integer for better performance
    scaled_values = [int(float(v) * scale_factor) for v in temp]
    return pyToSV(scaled_values)

# Read the input from the file
with open(inputFilePath, "r") as file:
    temp = file.read()

# Evaluate the input string to convert it into a Python object (list)
temp = eval(temp)

# Convert the Python list to SystemVerilog array format
temp = oneDToSv(temp)

# Write the converted array to the output file
with open(outputFilePath, "w") as file:
    file.write(temp)

print(f"Processed and saved SystemVerilog array format to {outputFilePath}")
