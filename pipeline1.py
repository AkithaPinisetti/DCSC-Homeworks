import sys
import pandas as pd


# Get input and output file paths from command line arguments
input_file = sys.argv[1]
output_file = sys.argv[2]

# Read the CSV file into a DataFrame
try:
    df = pd.read_csv(input_file)
except FileNotFoundError:
    print(f"File '{input_file}' not found.")
    sys.exit(1)

# add 10 to the 'horsepower' column)
df['horsepower'] = df['horsepower'] + 10

# Save the modified data to the output CSV file
df.to_csv(output_file, index=False)
