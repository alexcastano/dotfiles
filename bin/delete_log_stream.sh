#!/bin/sh

aws logs describe-log-streams --log-group-name "$1" --output text | awk '{print $7}' | while read x;
do aws logs delete-log-stream --log-group-name "$1" --log-stream-name $x
done
