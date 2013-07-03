#!/bin/bash -x

DIRECTORY=~/.kde4/Autostart/
if [ -d $DIRECTORY ]
then
  cp ../kde/ssh-add.sh $DIRECTORY
  echo "Successfull"
else
  echo "Error $DIRECTORY doesn't exits"
fi
