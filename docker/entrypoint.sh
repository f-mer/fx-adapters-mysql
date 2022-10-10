#!/bin/bash -e

rm -rf spec/dummy/{tmp,log}

export PATH="$PATH:/app"

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
