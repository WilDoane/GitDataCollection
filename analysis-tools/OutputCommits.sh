#!/bin/bash

# goal: checkout each version of a file (${1}) and generate 
#       an HTML file with that content

function usage () {
   cat <<EOS

${0} - Generate an HTML version of git commits for a given file. Output is stored in ~/gitdatacollection

Usage: ${0} file.c

Example:
  cd repositories
  curl -k https://raw.github.com/WilDoane/GitDataCollection/master/analysis-tools/OutputCommits.sh -o OutputCommits.sh
  chmod 700 OutputCommits.sh  
  cd git-repo-of-interest
  ../OutputCommits.sh setup.sh
  ../OutputCommits.sh week1/hw1.1.c

EOS
}

[[ -e "${1}" ]] || {            
    usage
    exit 1
}





defaultcss='
<style>
  a {
    font-size: 20pt;
  }

  td {
    vertical-align: top;
  }

  .changed {
    width: 100%;
    color: black;
    background: #00cc00;
  }

  .compileroutput {
    background: #cccccc;
    border: 1px ridge #999999;
    white-space: pre-wrap;
    font-family: monospace;
    display: block;
  }

</style>
'

# convert deep paths into simple filenames
FILENAME="$(echo $1 | tr '/' '_')"

OUTPUT_DIR=~/gitdatacollection

OUTPUT_FILE=$OUTPUT_DIR/$FILENAME.html


mkdir $OUTPUT_DIR
echo "<html><head>${defaultcss}</head><body><table><tr>"  > $OUTPUT_FILE

# get the commit hashes of every commit where $1 was touched
git whatchanged --pretty="%h %ai" ${1} | grep -e "^[0-9a-f]" | tail -r > ~/gittemp
echo "junk-to-ensure-first-commit-gets-output" >> ~/gittemp

reading_first_line="true"
while read commit_hash commit_date
do
  if ( $reading_first_line == "true" )
    then
      reading_first_line="false"
      read nearest_parent_hash np_commit_date
    else
      temp=$commit_hash
      commit_hash=$nearest_parent_hash
      nearest_parent_hash=$temp

      temp=$commit_date
      commit_date=$np_commit_date
      np_commit_date=$temp
  fi

  git checkout ${commit_hash}
  if [ -e ${1} ]; then
    echo "<td>" >> $OUTPUT_FILE
    echo "<a name='${commit_hash}'></a>" >> $OUTPUT_FILE
    #echo "<a href='#${nearest_parent_hash}'>EARLIER</a>" >> $OUTPUT_FILE 
    #echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" >> $OUTPUT_FILE 
    #echo "<a href='#$later'>LATER</a>" >> $OUTPUT_FILE 
    #echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" >> $OUTPUT_FILE 
    echo "${commit_hash} ${commit_date}" >> $OUTPUT_FILE 
    echo "<br />" >> $OUTPUT_FILE
    echo "<pre>" >> $OUTPUT_FILE 
    
    # get the raw git blame for $1 ...
    # pipe it into sed to wrap lines that changed in the current commit with an HTML span for styling...
    # and append the output to our HTML file
    git blame -ns ${1} | sed 's/'$commit_hash'.*/<span class="changed">&<\/span>/'  >> $OUTPUT_FILE
   
    echo "</pre>" >> $OUTPUT_FILE  

    # using awk to replace the end of line characters with HTML br tags
    # http://www.catonmat.net/blog/wp-content/uploads/2008/09/awk1line.txt
    log=`git log  -1 --pretty="%s<p>%b<p>%N" $commit_hash ${1} | awk ' { sub(/$/, "<br>"); print }'`

    # add the compiler call and compile-time error messages to the HTML output
    echo "<div class='compileroutput'>" >> $OUTPUT_FILE
    echo $log >> $OUTPUT_FILE
    echo "</div>" >> $OUTPUT_FILE
    echo "</td>" >> $OUTPUT_FILE

    # cp ${1} ../${1}.output/$commit1.html
    # do more here... add spans, add html
    # that happens when a file has been renamed over time in the git repo?


    # students won't be using git mv

    later=${commit_hash}

  fi

done < ~/gittemp

# return the repo to its current state
git checkout master

#rm ~/gittemp

echo "</tr></table></body></html>" >> $OUTPUT_FILE

# open the analysis HTML file in the user's default web browser
open "$OUTPUT_FILE"