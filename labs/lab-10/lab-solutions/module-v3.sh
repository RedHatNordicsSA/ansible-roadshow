#!/bin/sh
# Module which creates the file: /tmp/module-file
set -e
# First argument is the arguments file
source ${1}
# Create file
# Evaluate if the file exists first.
if [ -f /tmp/module-file ]; then
  STATE=present
else
  STATE=absent
  touch /tmp/module-file
fi

# Output JSON
# If touch exits with 0, creation was successful
if [ "$?" -eq 0 ]; then
  case $STATE in
    present)
      echo {\"changed\": false, \"msg\": \"${msg}\"}
      ;;
    absent)
      echo {\"changed\": true, \"msg\": \"${msg}\"}
      ;;
  esac
# We failed to create the file
else
  echo {\"failed\": true, \"msg\": \"${msg}\"}
fi
exit 0
