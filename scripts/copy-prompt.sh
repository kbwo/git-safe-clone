#!/bin/bash

# Create or clear the .clinerules file
> .clinerules

# Find all .mdc files in .cursor/rules, sort them by name
for file in $(find .cursor/rules -name "*.mdc" | sort); do
  # Get the filename without path and extension
  filename=$(basename "$file" .mdc)
  
  # Create a temporary file to store the content without frontmatter
  temp_file=$(mktemp)
  
  # Process the file to remove frontmatter (content between --- markers)
  awk '
    BEGIN { skip = 0; found_first = 0; }
    /^---$/ { 
      if (!found_first) {
        found_first = 1;
        skip = 1;
      } else {
        skip = 0;
        next;
      }
    }
    !skip { print }
  ' "$file" > "$temp_file"
  
  # Append the processed content to the .clinerules file
  # Add a header with the filename for better organization
  echo "# $filename" >> .clinerules
  cat "$temp_file" >> .clinerules
  echo "" >> .clinerules  # Add an empty line for separation
  
  # Remove the temporary file
  rm "$temp_file"
  
  echo "Appended $file to .clinerules"
done

echo "All .mdc files have been appended to the .clinerules file"
