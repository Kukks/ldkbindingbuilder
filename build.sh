#!/bin/bash

# Set up variables
localOutputFolder="local_output_folder"
imageName="ldk-garbagecollected-image"

# Build the Docker image
docker build -t "$imageName" .

# Create a local folder to store the output
mkdir -p "$localOutputFolder"

# Run the Docker container with your entrypoint script
docker run -v "$(pwd)/$localOutputFolder:/app/local_output" "$imageName"

# Clean up by removing the Docker image (optional)
# docker rmi "$imageName"

echo "Output files are copied to $localOutputFolder"
