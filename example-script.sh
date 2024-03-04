#!/bin/bash
#
# Upload/download to/from a self-hosted Send service
#
# Example Send host setting using send.neoman.dev
# Change this to the desired Send host URL
export FFSEND_HOST="https://send.neoman.dev"

# Stop on error
set -e

# Upload a file
# -I: no interaction
# -y: assume yes
# -q: quiet output, just return the share link
URL=$(ffsend -Iy upload -q my-file.txt)

# Render file information
# -I: no interaction
# -f: force, just show the info
ffsend -If info $URL

# Set a password for the uploaded file
ffsend -I password $URL --password="secret"

# Use the following flags automatically from now on
# -I: no interaction
# -f: force
# -y: yes
export FFSEND_NO_INTERACT=1 FFSEND_FORCE=1 FFSEND_YES=1

# Download the uploaded file, overwriting the local variant due to variables
ffsend download $URL --password="secret"
