#!/bin/bash

# goal: checkout each version of a file ($1) and generate 
#       an HTML file with that content

mkdir ../$1.output

git log --pretty=format:"%h %p %ai" > ~/gittemp

while read commit1 commit2 commitdate
do
  git co $commit1
  if [ -e $1 ]; then
    cp $1 ../$1.output/$commit1.html
  fi

done < ~/gittemp

git co master

rm ~/gittemp