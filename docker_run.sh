#!/bin/bash
set -euo pipefail

# Run as the calling user so files written to the mounted volume stay owned by
# you. Pass a command to run non-interactively, otherwise you get a shell.
docker run --rm -it \
    --user "$(id -u):$(id -g)" \
    --volume /home:/home \
    --workdir "$PWD" \
    latex:latest "${@:-bash}"
