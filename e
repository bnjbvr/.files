#!/bin/sh -x
# street cred to padenot

# Connect to an existing gvim instance, or run a gvim if none is available

list=$(vim --serverlist)

if [ -z "$list" ]
then
  /usr/bin/gvim $*
else
  /usr/bin/gvim --remote-silent $*
fi