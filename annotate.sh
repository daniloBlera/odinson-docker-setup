#!/bin/sh
# Annotate the plaintext documents
ODINSON_DATA_HOME="$(pwd)/data/odinson"

docker run \
  --name="odinson-extras" \
  -it \
  --rm \
  -e "HOME=/app" \
  -e "JAVA_OPTS=-Dodinson.extra.processorType=CluProcessor" \
  -v "$ODINSON_DATA_HOME:/app/data/odinson" \
  --entrypoint "bin/annotate-text" \
  "lumai/odinson-extras:latest"
