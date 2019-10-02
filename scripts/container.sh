#!/bin/bash

# Auto Configure Project Path And Additional Variables
# shellcheck disable=SC2164
scriptPath="$( cd "$(dirname "$0")" ; pwd -P )"
projectPath="$(dirname "${scriptPath}")"
CMDLINE=${CMDLINE:-'alpine:latest /bin/bash'}

# Execute An Interactive Docker Session
# shellcheck disable=SC2086
docker run -t --rm \
    --volume /tmp:/tmp --volume "${projectPath}:/project" --volume /etc/ssl/certs:/etc/ssl/certs \
    --volume /etc/localtime:/etc/localtime:ro \
    ${CMDLINE}
