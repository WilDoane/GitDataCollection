#!/bin/bash

# goal: checkout each version of a file (${1}) and generate 
#       an HTML file with that content

function usage () {
   cat <<EOS
${0} - Generate an HTML version of git commits for a given file

Usage: ${0} file.txt

Examples:
  cd ~/repositories/project-of-interest
  ${0} setup.sh
  ${0} week1/hw1.1.c

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
  .changed {
    color: black;
    background: #00cc00;
  }
</style>
'

OUTPUT_DIR=~/gitdatacollection

OUTPUT_FILE=$OUTPUT_DIR/index.html



mkdir $OUTPUT_DIR
echo "<html><head>${defaultcss}</head><body>"  > $OUTPUT_FILE

# my data source in the form 
#   2f3512a1 1a4f1b51
# git log --pretty=format:"%h %p" > ~/gittemp


git whatchanged --pretty="%h %ai" ${1} | grep -e "^[0-9a-f]" > ~/gittemp


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

  git co ${commit_hash}
  if [ -e ${1} ]; then
    echo "<a name='${commit_hash}'></a>" >> $OUTPUT_FILE
    echo "<a href='#${nearest_parent_hash}'>EARLIER</a>" >> $OUTPUT_FILE 
    echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" >> $OUTPUT_FILE 
    echo "<a href='#$later'>LATER</a>" >> $OUTPUT_FILE 
    echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" >> $OUTPUT_FILE 
    echo "${commit_hash} ${commit_date}" >> $OUTPUT_FILE 
    echo "<br />" >> $OUTPUT_FILE
    echo "<pre>" >> $OUTPUT_FILE 
    
    git blame -nsb ${1} > ~/gitblame

    while read line
    do
      if [[ ${line} =~ "${commit_hash}" ]]
        then
          echo -n "<span class='changed'>" >> $OUTPUT_FILE
      fi

      echo "$line" >> $OUTPUT_FILE

      if [[ ${line} =~ "${commit_hash}" ]]
        then
          echo -n "</span>" >> $OUTPUT_FILE
      fi
    done < ~/gitblame




    #git blame -nsb ${1} >> $OUTPUT_FILE
    

    #cat ${1} >> $OUTPUT_FILE
    echo "</pre>" >> $OUTPUT_FILE  
    echo "<br />&nbsp;<hr />&nbsp;<br />&nbsp;" >> $OUTPUT_FILE

    # cp ${1} ../${1}.output/$commit1.html
    # do more here... add spans, add html
    # that happens when a file has been renamed over time in the git repo?


    # students won't be using git mv

    later=${commit_hash}

  fi

done < ~/gittemp

git co master

#rm ~/gittemp

echo "</body></html>" >> $OUTPUT_FILE

open "$OUTPUT_FILE"