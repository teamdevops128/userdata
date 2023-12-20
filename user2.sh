#!/bin/bash

# GitHub Organization Name
ORG_NAME="your_organization_name"
# GitHub Token (Ensure you have a Personal Access Token with necessary permissions)
GITHUB_TOKEN="your_personal_access_token"

# API endpoints
ORG_API="https://api.github.com/orgs/$ORG_NAME/repos"
HEADER="Authorization: token $GITHUB_TOKEN"
COLLABORATORS_API="https://api.github.com/repos/$ORG_NAME/{repo}/collaborators"

# Fetch repositories for the organization
repos=$(curl -s -H "$HEADER" "$ORG_API" | jq '.[].name' -r)

echo "Repository Name,Number of Collaborators"

# Loop through each repository to fetch collaborators
for repo in $repos; do
    collaborators_count=$(curl -s -H "$HEADER" "${COLLABORATORS_API/\{repo\}/$repo}" | jq 'length')
    
    # Print repository name and number of collaborators
    echo "$repo,$collaborators_count"
done
