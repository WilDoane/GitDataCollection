#!/bin/bash

# if the line contains the given hash code, prefix it with an asterisk

while read line
do
  if [[ ${line} =~ "ddf28ed" ]]
  	then
      echo -n "* "
  fi
  echo "$line"
done < "$1"

exit
