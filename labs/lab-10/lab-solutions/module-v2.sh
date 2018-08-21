#!/bin/sh
# Module which creates the file: /tmp/module-file
set -e
# First argument is the arguments file
source ${1}
# Create file
touch /tmp/module-file

# Output JSON
# If touch exits with 0, creation was successful
if [ "$?" -eq 0 ]; then
  echo {\"changed\": true, \"msg\": \"${msg}\"}
# We failed to create the file
else
  echo {\"failed\": true, \"msg\": \"${msg}\"}
fi
exit 0
