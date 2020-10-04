#!/bin/sh
# Index the annotated documents
# Only, run this after after the annotation script
ODINSON_DATA_HOME="$(pwd)/data/odinson"

docker run \
  --name="odinson-extras" \
  -it \
  --rm \
  -e "HOME=/app" \
  -v "$ODINSON_DATA_HOME:/app/data/odinson" \
  --entrypoint "bin/index-documents" \
  "lumai/odinson-extras:latest"
