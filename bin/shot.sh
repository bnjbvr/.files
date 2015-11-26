#!/bin/sh

# Usage : shot.sh, select a zone of the screen.

filename="`date +%s`.png"
if [ ! -z "$1" ]
then
    filename=$1.png
fi

scrot -s -q 100 /tmp/$filename
up /tmp/$filename

if [ $? = "0" ]
then
  rm /tmp/$filename
else
  echo "Could not upload the file /tmp/$filename"
fi
