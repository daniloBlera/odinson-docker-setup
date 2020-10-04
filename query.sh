#!/bin/sh
ODINSON_DATA_HOME="$(pwd)/data/odinson"
HOST_IP='0.0.0.0'
HOST_PORT='9001'
CONTAINER_PORT='9000'

docker run \
    --name="odinson-rest-api" \
    -it \
    --rm \
    -e "HOME=/app" \
    -p "$HOST_IP:$HOST_PORT:$CONTAINER_PORT" \
    -v "$ODINSON_DATA_HOME:/app/data/odinson" \
    "lumai/odinson-rest-api:latest"
