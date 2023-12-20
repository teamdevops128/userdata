#!/bin/bash
ORG_NAME="your_organization_name"
OUTPUT_FILE="collaborators_data.csv"
ORG_API="https://api.github.com/orgs/$ORG_NAME/repos"
HEADER="Authorization: token $GITHUB_TOKEN"
COLLABORATORS_API="https://api.github.com/repos/$ORG_NAME/{repo}/collaborators"
echo "Repository Name,Collaborators" > "$OUTPUT_FILE"
fetch_repos() {
    local page=1
    while true; do
        local repos=$(curl -s -H "$HEADER" "$ORG_API?page=$page&per_page=100" | jq '.[].name' -r)
        if [ -z "$repos" ]; then
            break
        fi
        for repo in $repos; do
            fetch_and_save_collaborators "$repo"
        done
        ((page++))
    done
}
fetch_and_save_collaborators() {
    local repo="$1"
    local collaborators=$(curl -s -H "$HEADER" "${COLLABORATORS_API/\{repo\}/$repo}" | jq -r '.[].login' | tr '\n' ';') # Combine collaborators with a semicolon
    echo "$repo,\"$collaborators\"" >> "$OUTPUT_FILE"
}

fetch_repos

echo "Collaborator data saved to $OUTPUT_FILE"
