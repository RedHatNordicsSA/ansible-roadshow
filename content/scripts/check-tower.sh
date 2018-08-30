#!/bin/bash
# simple script to see that ansible tower is up and running
PASSWD=redhat123
FAIL=0
OK=0
for i in $(cat ../tower_servers.out)
do
  curl -H "Content-Type: application/json" -X GET -s -u admin:$PASSWD -k https://$i/api/v2/ping/ --connect-timeout 1 >/dev/nul
  if [ "$?" -eq 0 ]
  then
    echo "$i: OK"
    ((OK++))
  else
    echo "$i: FAIL"
    ((FAIL++))
  fi
done
echo "OK=$OK FAIL=$FAIL"
