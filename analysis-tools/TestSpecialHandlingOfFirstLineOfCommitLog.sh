#!/bin/bash

reading_first_line="true"

while read commit_hash
do
  if ( $reading_first_line == "true" )
  	then
  	  reading_first_line="false"
 	  read nearest_parent_hash
 	else
 	  temp=$commit_hash
 	  commit_hash=$nearest_parent_hash
 	  nearest_parent_hash=$temp
 	fi
  echo "$commit_hash $nearest_parent_hash"
done < input.txt
