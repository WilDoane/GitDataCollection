#!/bin/bash

# goal: checkout each version of a file ($1) and generate 
#       an HTML file with that content

mkdir ../$1.output
echo "<html><body>" > ../$1.output/index.html

git log --pretty=format:"%h %p %ai" > ~/gittemp

while read present earlier commitdate
do
  git co $present
  if [ -e $1 ]; then
	echo "<a name='$present'></a>" >> ../$1.output/index.html
	echo "<a href='#$earlier'>EARLIER</a>" >> ../$1.output/index.html 
	echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" >> ../$1.output/index.html 
	echo "<a href='#$later'>LATER</a>" >> ../$1.output/index.html 
	echo "<br />" >> ../$1.output/index.html
	echo "<pre>" >> ../$1.output/index.html	
	cat $1 >> ../$1.output/index.html
	echo "</pre>" >> ../$1.output/index.html	
	echo "<br />&nbsp;<hr />&nbsp;<br />&nbsp;" >> ../$1.output/index.html

    # cp $1 ../$1.output/$commit1.html
    # do more here... add spans, add html
    # that happens when a file has been renamed over time in the git repo?


    # students won't be using git mv

    later=$present

  fi

done < ~/gittemp

git co master

rm ~/gittemp

echo "</body></html>" >> ../$1.output/index.html


a b
b c 