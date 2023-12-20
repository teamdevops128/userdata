#!/bin/bash

# GitHub Organization Name
ORG_NAME="your_organization_name"
# GitHub Token (Ensure you have a Personal Access Token with necessary permissions)

KEEP_USER="username_to_keep"
# API endpoint for organization repositories
ORG_API="https://api.github.com/orgs/$ORG_NAME/repos"
# Authorization header
HEADER="Authorization: token $(TOKEN)"
# Output CSV File
OUTPUT_CSV="collaborators_removed.csv"

# Initialize CSV header
echo "Repository Name,Collaborator Removed" > "$OUTPUT_CSV"

# Fetch repositories for the organization
repos=$(curl -s -H "$HEADER" "$ORG_API" | jq '.[].full_name' -r)

echo "Starting to remove collaborators..."

# Loop through each repository
for repo in $repos; do
    # Fetch collaborators for the repository
    collaborators=$(curl -s -H "$HEADER" "https://api.github.com/repos/$repo/collaborators" | jq '.[].login' -r)
    
    # Loop through each collaborator
    for collaborator in $collaborators; do
        if [ "$collaborator" != "$KEEP_USER" ]; then
            echo "Removing collaborator: $collaborator from repository: $repo"
            
            # Remove collaborator from repository
            curl -s -X DELETE -H "$HEADER" "https://api.github.com/repos/$repo/collaborators/$collaborator"
            
            # Append collaborator removed to CSV file
            echo "$repo,$collaborator" >> "$OUTPUT_CSV"
            
            echo "Removed collaborator: $collaborator from repository: $repo"
        fi
    done
done

echo "Completed removing collaborators. Collaborators removed details saved to $OUTPUT_CSV"
