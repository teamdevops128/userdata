#!/bin/bash
# Output CSV file
OUTPUT_CSV="collaborators.csv"
# GitHub API endpoint for collaborators
API_ENDPOINT="https://api.github.com/repos"
REPOS=("python-app" "python-app-pushdocker")
# Create or truncate the CSV file
echo "Repository, Collaborators" > "$OUTPUT_CSV"
# Loop through each repository
for REPO in "${REPOS[@]}"; do
    # Fetch collaborators using GitHub API
    COLLABORATORS=$(curl -s -H "Authorization: token $TOKEN" "$API_ENDPOINT/$USERNAME/$REPO/collaborators" | jq -r '.[].login' | tr '\n' ',' | sed 's/,$//')
    # Append to the CSV file
    echo "$REPO, $COLLABORATORS" >> "$OUTPUT_CSV"
    # Add a space after each iteration
    echo "Waiting for a moment before the next iteration..."
    sleep 1
done
echo "Collaborators information has been saved to $OUTPUT_CSV"
