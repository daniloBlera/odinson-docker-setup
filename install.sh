#!/bin/sh
# Install odinson docker images, annotate and index the supplied test document.
# 
# This script will run docker commands so make sure its daemon is running
# before executing this file

# Download the images
docker pull 'lumai/odinson-extras:latest'
docker pull 'lumai/odinson-rest-api:latest'

# The absolute path to the data directory tree
ODINSON_DATA_HOME="$(pwd)/data/odinson"

# Create the directory tree, copy the test data and fix file permissions
mkdir -p "$ODINSON_DATA_HOME/text"
unzip -d './data/odinson/text' './test-document.zip'
chmod -R 777 "$ODINSON_DATA_HOME"

# Annotate documents
docker run \
    --name="odinson-extras" \
    -it \
    --rm \
    -e "HOME=/app" \
    -e "JAVA_OPTS=-Dodinson.extra.processorType=CluProcessor" \
    -v "$ODINSON_DATA_HOME:/app/data/odinson" \
    --entrypoint "bin/annotate-text" \
    "lumai/odinson-extras:latest"

# Index annotations
docker run \
    --name="odinson-extras" \
    -it \
    --rm \
    -e "HOME=/app" \
    -v "$ODINSON_DATA_HOME:/app/data/odinson" \
    --entrypoint "bin/index-documents" \
    "lumai/odinson-extras:latest"
