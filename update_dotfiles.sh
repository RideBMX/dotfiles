#!/bin/bash

# Step 1: Initialize or pull from the git repository
repo_path="$HOME/dotfiles"
if [ -d "$repo_path/.git" ]; then
    # Git repository exists, pull the latest changes
    cd "$repo_path" || exit
    git pull origin master
else
    # Git repository does not exist, initialize and create README.md
    git init "$repo_path"
    echo "Initial commit for dotfiles repo." > "$repo_path/README.md"
    cd "$repo_path" || exit
    git add README.md
    git commit -m "Initial commit"
fi

# Step 2: Define folders to exclude
exclude_folders=("$HOME/.wine" "$HOME/.test")

# Step 3: Find dotfiles, preserve directory structure, and add them to the repo
find "$HOME" -name ".*" -type f | while read -r dotfile_path; do
    excluded=false
    for folder in "${exclude_folders[@]}"; do
        if [[ "$dotfile_path" == "$folder"* ]]; then
            excluded=true
            break
        fi
    done

    if [ "$excluded" = false ]; then
        relative_path=$(realpath --relative-to="$HOME" "$dotfile_path")
        mkdir -p "$(dirname "$repo_path/$relative_path")"
        cp "$dotfile_path" "$repo_path/$relative_path"
    fi
done

# Step 4: Add and commit changes
cd "$repo_path" || exit
git add .
git commit -m "Add dotfiles"
git push origin master
