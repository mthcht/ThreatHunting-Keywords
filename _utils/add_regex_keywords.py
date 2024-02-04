import pandas as pd

# Function to convert a keyword into a regex pattern
def string_to_regex_pattern(input_string):
    regex_pattern = input_string.replace("\\", "\\\\").replace("\"\"", "\"")\
    .replace("\"", "\\\"").replace(".", "\\.").replace(" ", "\\s")\
    .replace("|", "\\|").replace("/", "\\/").replace("(", "\\(").replace(")", "\\)")\
    .replace('+','\+').replace("&","\\&").replace('?','\?').replace('[','\[')\
    .replace(']','\]').replace("'","\\'").replace('-','\-').replace('!','\!').replace('#','\#')\
    .replace('"','\"').replace('^','\^').replace('%','\%').replace('=','\=').replace('$','\$')\
    .replace(';','\;').replace(',','\,').replace('<','\<').replace('>','\>').replace('@','\@')\
    .replace('}','\}').replace('{','\{').replace('`','\`').replace('~','\~').replace(':','\:')\
    .replace('*', '.{0,1000}')
    return regex_pattern
    
def update_metadata_regex(df):
    for index, row in df.iterrows():
        # Check if 'metadata_keyword_regex' is "N/A" or equivalent
        if pd.isna(row['metadata_keyword_regex']) or row['metadata_keyword_regex'].strip().upper() == 'N/A':
            # Generate and assign the new regex pattern
            new_regex = string_to_regex_pattern(row['keyword'])
            df.at[index, 'metadata_keyword_regex'] = new_regex

    return df
# Load CSV file
df = df = pd.read_csv('../threathunting-keywords.csv', na_values=[], keep_default_na=False)

# Check and update 'metadata_keyword_regex' where value is 'N/A'
for index, row in df.iterrows():
    if row['metadata_keyword_regex'] == 'N/A':
        df.at[index, 'metadata_keyword_regex'] = string_to_regex_pattern(row['keyword'])

# Save the updated DataFrame back to CSV
df.to_csv('updated_threathunting-keywords.csv', index=False)
