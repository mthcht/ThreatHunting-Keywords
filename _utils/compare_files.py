import pandas as pd
import tkinter as tk
from tkinter import filedialog

def select_file(title="Select a CSV file"):
    """Prompt the user to select a CSV file."""
    root = tk.Tk()
    root.withdraw()  # Hide the root window
    file_path = filedialog.askopenfilename(title=title, filetypes=[("CSV files", "*.csv")])
    return file_path

def load_csv(file_path):
    """Load a CSV file into a DataFrame."""
    try:
        return pd.read_csv(file_path)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return None

def compare_csvs(file1_path, file2_path):
    """Compare two CSV files and find added or removed lines."""
    df1 = load_csv(file1_path)
    df2 = load_csv(file2_path)
    
    if df1 is None or df2 is None:
        return

    # Find added lines
    added_lines = pd.merge(df2, df1, how='outer', indicator=True)
    added = added_lines[added_lines['_merge'] == 'left_only'].drop(columns=['_merge'])

    # Find removed lines
    removed_lines = pd.merge(df1, df2, how='outer', indicator=True)
    removed = removed_lines[removed_lines['_merge'] == 'left_only'].drop(columns=['_merge'])

    # Display all rows without truncation
    pd.set_option('display.max_rows', None)
    pd.set_option('display.max_columns', None)
    pd.set_option('display.width', None)

    # Convert DataFrame to CSV format string
    added_csv = added.to_csv(index=False)
    removed_csv = removed.to_csv(index=False)

    print(f"\n--- New Lines in {file2_path} (Added) ---")
    if not added.empty:
        print(added_csv)
    else:
        print("No new lines added.")

    print(f"\n--- Missing Lines from {file2_path} (Removed) ---")
    if not removed.empty:
        print(removed_csv)
    else:
        print("No lines removed.")

    # Optionally save the results
    added.to_csv('AddedLines.csv', index=False)
    removed.to_csv('RemovedLines.csv', index=False)
    print("\nResults saved to 'AddedLines.csv' and 'RemovedLines.csv'.")

def main():
    print("Select the older CSV file for comparison:")
    file1_path = select_file("Select the older CSV file")
    
    print("Select the newer CSV file for comparison:")
    file2_path = select_file("Select the newer CSV file")
    
    if not file1_path or not file2_path:
        print("File selection was cancelled.")
        return

    print(f"\nComparing files:\n- Older file: {file1_path}\n- Newer file: {file2_path}\n")
    compare_csvs(file1_path, file2_path)

if __name__ == "__main__":
    main()
