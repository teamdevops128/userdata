#!/bin/bash

# GitHub Organization Name
ORG_NAME="your_organization_name"

# User to keep as a collaborator
KEEP_USER="username_to_keep"
# API endpoint for organization repositories
ORG_API="https://api.github.com/orgs/$ORG_NAME/repos"
# Authorization header. As token we are passing as a variable in the file
HEADER="Authorization: token $(TOKEN)"

# Get repositories for the organization
repos=$(curl -s -H "$HEADER" "$ORG_API" | jq '.[].full_name' -r)

# Loop through each repository
for repo in $repos; do
    # Fetch collaborators for the repository
    collaborators=$(curl -s -H "$HEADER" "https://api.github.com/repos/$repo/collaborators" | jq '.[].login' -r)
    
    # Loop through each collaborator and remove if not the specified user
    for collaborator in $collaborators; do
        if [ "$collaborator" != "$KEEP_USER" ]; then
            echo "Removing $collaborator from $repo"
            # Remove collaborator from repository
            curl -s -X DELETE -H "$HEADER" "https://api.github.com/repos/$repo/collaborators/$collaborator"
        fi
    done
done

echo "Completed removing collaborators."
