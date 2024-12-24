#!/bin/bash

# Initialize the output file
> /etc/coder/coder-agent.conf

# Loop through all .env files in /etc/coder and append their contents
for file in /etc/coder/*.env; do
    if [ -f "$file" ]; then
        echo "Appending $file to /etc/coder/coder-agent.conf"
        cat "$file" >> /etc/coder/coder-agent.conf
    else
        echo "No .env files found in /etc/coder"
    fi
done

# Log the final result
if [ -s /etc/coder/coder-agent.conf ]; then
    echo "Successfully concatenated .env files into /etc/coder/coder-agent.conf"
else
    echo "No files were appended. /etc/coder/coder-agent.conf is empty."
fi
