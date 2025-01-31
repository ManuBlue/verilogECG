import os

# Paths for the input and output files
scriptDir = os.path.dirname(os.path.abspath(__file__))
inputFilePath = os.path.join(scriptDir, "input.txt")
outputFilePath = os.path.join(scriptDir, "output.txt")
def convert_to_matlab_array(python_array):
    """
    Converts a Python-style array (list of lists or list) to a MATLAB-style array string.
    """
    if isinstance(python_array, list):
        if all(isinstance(row, list) for row in python_array):  # 2D array
            # Transpose the array before converting (inverts rows and columns)
            python_array = list(map(list, zip(*python_array)))
            matlab_array = "[" + "; ".join(" ".join(map(str, row)) for row in python_array) + "]"
        elif all(isinstance(item, (int, float, str)) for item in python_array):  # 1D array
            matlab_array = "[" + " ".join(map(str, python_array)) + "]"
        else:
            raise ValueError("Input array contains invalid elements.")
        return matlab_array
    raise ValueError("Input is not a valid Python-style array.")

import ast

def main():
    try:
        # Read the input file
        with open(inputFilePath, "r") as file:
            python_array = ast.literal_eval(file.read())  # Use literal_eval for safety
        # Convert the Python array to MATLAB array format
        matlab_array = convert_to_matlab_array(python_array)
        # Write the MATLAB array to the output file
        with open(outputFilePath, "w") as file:
            file.write(matlab_array)
        
        print(f"MATLAB array saved to {outputFilePath}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
