#!/bin/bash -x

DIRECTORY=~/.kde4
if [ -d $DIRECTORY ]
then
  for i in ../kde4/*
  do
    cp -rf $i $DIRECTORY
  done
  echo "Successfull"
else
  echo "Error $DIRECTORY doesn't exits"
fi
