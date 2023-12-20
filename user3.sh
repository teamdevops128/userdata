#!/bin/bash


ORG_NAME="your_organization_name"
OUTPUT_FILE="collaborators_count.csv"
ORG_API="https://api.github.com/orgs/$ORG_NAME/repos"
HEADER="Authorization: token $(TOKEN)"
COLLABORATORS_API="https://api.github.com/repos/$ORG_NAME/{repo}/collaborators"

# Function to fetch repositories using pagination
fetch_repos() {
    local page=1
    while true; do
        local repos=$(curl -s -H "$HEADER" "$ORG_API?page=$page&per_page=100" | jq '.[].name' -r)
        if [ -z "$repos" ]; then
            break
        fi
        for repo in $repos; do
            fetch_collaborators "$repo"
        done
        ((page++))
    done
}

# Function to fetch collaborators for a repository
fetch_collaborators() {
    local repo="$1"
    local collaborators_count=$(curl -s -H "$HEADER" "${COLLABORATORS_API/\{repo\}/$repo}" | jq 'length')
    echo "$repo,$collaborators_count" >> "$OUTPUT_FILE"
}
echo "Repository Name,Number of Collaborators" > "$OUTPUT_FILE"
# Fetch repositories and collaborators
fetch_repos

echo "Data saved to $OUTPUT_FILE"
