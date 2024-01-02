#!/bin/bash

# Check if the folder route is provided as a parameter
if [ $# -eq 0 ]; then
  echo "Please provide the folder route of the Git repository."
  exit 1
fi

# Store the folder route parameter
repository_folder="$1"

# Change to the specified repository folder
cd "$repository_folder" || exit

# Dynamically find the main branch (either 'master' or 'main')
main_branch=""
if git rev-parse --verify master > /dev/null 2>&1; then
    main_branch="master"
elif git rev-parse --verify main > /dev/null 2>&1; then
    main_branch="main"
else
    echo "Neither 'master' nor 'main' branches found."
    exit 1
fi

# Switch to the main branch
git -C "$repository_folder" switch "$main_branch"

# Pull the latest changes from the remote repository
git -C "$repository_folder" pull

# Get a list of branches excluding the main branch
branches=$(git branch --format="%(refname:short)" | grep -vE "$main_branch|cluster-aux")

# Iterate over all branches
for branch in $branches; do
  # Checkout the branch
  git -C "$repository_folder" checkout "$branch"

  # Rebase the branch onto the latest main branch
  git -C "$repository_folder" rebase "$main_branch"

  # Force push changes
  # git -C "$repository_folder" push -f
done

# Switch back to the main branch
git -C "$repository_folder" switch "$main_branch"
