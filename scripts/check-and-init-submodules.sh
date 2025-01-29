#!/bin/sh

# Function to check if a submodule is initialized
check_submodule_initialized() {
    [ -d "$1/.git" ]
}

# Save the original IFS
OLDIFS=$IFS
IFS=$'\n'

# Get the list of submodules
#submodules=$(git config --file .gitmodules --get-regexp path | sed 's/^submodule\.//' | sed 's/\.path.*//' | sed 's/ /\\ /g')
submodules=$(git config --file .gitmodules --get-regexp path | sed 's/^submodule\.//' | sed 's/\.path.*//')
echo "That are the submodules $submodules"

# Loop through each submodule and check if it is initialized
for submodule in $submodules; do
    if ! check_submodule_initialized "'$submodule'"; then
        echo "$submodule is not initialized."
        read -p "Do you want to initialize $submodule? (y/n) " choice
        if [ "$choice" = "y" ]; then
            git submodule update --init --recursive "$submodule"
        fi
    fi
done

# Restore the original IFS
IFS=$OLDIFS