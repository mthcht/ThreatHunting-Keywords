import csv
import sys


if len(sys.argv) < 3:
    print("list1 contains your list of strings to search (one by line) in the list2 first column\n Usage: python script.py list1.csv list2.csv")
    sys.exit(1)

# Paths to the CSV files provided as command-line arguments
file_path1 = sys.argv[1]
file_path2 = sys.argv[2]

# Load the first list from CSV
with open(file_path1, newline='') as file1:
    reader1 = csv.reader(file1)
    list1 = [row[0] for row in reader1 if row]

# Prepare results dictionary with all entries from list1 set to False initially
results = {string: False for string in list1}

# Stream the second list and check if any string from list1 is a substring of the first column entries
with open(file_path2, newline='') as file2:
    reader2 = csv.reader(file2)
    for row in reader2:
        if row:  # Ensure the row is not empty
            first_column_entry = row[0]  # Only consider the first column of list2
            for string in list1:
                if string in first_column_entry:
                    results[string] = True

# Displaying the results
for string, is_found in results.items():
    print(f"'{string}' is in list2: {is_found}")
