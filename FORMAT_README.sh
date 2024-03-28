#!/usr/bin/env bash

# Set Internal Field Separator to newline to handle spaces in filenames properly
IFS=$'\n'

# Function to process README.md file
function process_readme() {
  local header
  local body

  # Set Internal Field Separator to newline to handle spaces in filenames properly
  IFS=$'\n'
  # Loop through each line in README.md
  for line in $(cat -E README.md); do
    # Clean the line by removing trailing '$'
    local cleaned_line=$(echo "$line" | sed 's/\$$//')

    # Check if the line starts with alphabets
    if echo "$cleaned_line" | grep '^[a-zA-Z]' >/dev/null; then
      # Append to the body if it's a part of the previous section
      body="$body$cleaned_line\n"
    elif [[ "$body" != "" ]]; then
      # Format the body and print if a new section is detected
      local formatted_body=$(echo -e "$body" | column -s= -o' = ' -L -t | sed 's/^ .*//')
      echo -e "$formatted_body"
      body=''
      echo "$cleaned_line"
    else
      # Print the line if it's not a part of any section
      echo "$cleaned_line"
    fi
  done
}

# Remove spaces around '=' in README.md
sed -ri 's/\s*=\s/=/' README.md
# Process README.md and redirect output to a temporary file
process_readme >temp_file
# Replace README.md with the processed content
mv temp_file README.md
