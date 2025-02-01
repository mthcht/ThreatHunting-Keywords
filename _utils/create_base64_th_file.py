import csv
import base64
from pathlib import Path

def process_keyword(keyword, metadata_tags):
    # Remove leading and trailing wildcards (*)
    if keyword.startswith('*'):
        keyword = keyword[1:]
    if keyword.endswith('*'):
        keyword = keyword[:-1]
    # Skip rows if any wildcard remains in the middle or if keyword is empty
    if not keyword or '*' in keyword:
        return None
    # If metadata_tags indicates the keyword is already in base64, don't re-encode
    if '#base64' in metadata_tags:
        return keyword
    # Otherwise, return the Base64-encoded keyword
    return base64.b64encode(keyword.encode('utf-8')).decode('utf-8')

# Cross-platform file paths
input_file = Path("..") / "threathunting-keywords.csv"
output_file = Path("..") / "threathunting-keywords_base64_format.csv"

with input_file.open('r', newline='', encoding='utf-8') as infile, \
     output_file.open('w', newline='', encoding='utf-8') as outfile:
    
    reader = csv.DictReader(infile)
    fieldnames = reader.fieldnames  # Preserve all original fields
    writer = csv.DictWriter(outfile, fieldnames=fieldnames)
    writer.writeheader()
    
    for row in reader:
        original_keyword = row.get('keyword', '')
        metadata_tags = row.get('metadata_tags', '')
        new_keyword = process_keyword(original_keyword, metadata_tags)
        if new_keyword is None:
            continue  # Skip rows with internal wildcards
        row['keyword'] = new_keyword
        writer.writerow(row)
