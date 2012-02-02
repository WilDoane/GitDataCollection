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
</style>
'






mkdir ../${1}.output
echo "<html>${defaultcss}<body>"  > ../${1}.output/index.html

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
    echo "<a name='${commit_hash}'></a>" >> ../${1}.output/index.html
    echo "<a href='#${nearest_parent_hash}'>EARLIER</a>" >> ../${1}.output/index.html 
    echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" >> ../${1}.output/index.html 
    echo "<a href='#$later'>LATER</a>" >> ../${1}.output/index.html 
    echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" >> ../${1}.output/index.html 
    echo "${commit_hash} ${commit_date}" >> ../${1}.output/index.html 
    echo "<br />" >> ../${1}.output/index.html
    echo "<pre>" >> ../${1}.output/index.html 
    cat ${1} >> ../${1}.output/index.html
    echo "</pre>" >> ../${1}.output/index.html  
    echo "<br />&nbsp;<hr />&nbsp;<br />&nbsp;" >> ../${1}.output/index.html

    # cp ${1} ../${1}.output/$commit1.html
    # do more here... add spans, add html
    # that happens when a file has been renamed over time in the git repo?


    # students won't be using git mv

    later=${commit_hash}

  fi

done < ~/gittemp

git co master

#rm ~/gittemp

echo "</body></html>" >> ../${1}.output/index.html

open "../${1}.output/index.html"