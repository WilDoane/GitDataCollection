# An instrumentation of the gcc compiler command to push to a GitHub repository

# where is the real gcc located? to find out, type at the command prompt
#   which gcc

GCC=/usr/local/bin/gcc

# run gcc with the full list of arguments from the CLI ($@), 
# capturing STDERR (2) to STDOUT (&1)
# and store the STDOUT (i.e., the compiler output) in the variable RESULT
RESULT=$($GCC $@ 2>&1)

# add modified AND new files to the index
# Redirection solution adapted from http://www.xaprb.com/blog/2006/06/06/what-does-devnull-21-mean/
git add . > /dev/null 2>&1

# add deleted files to the index
git add -u > /dev/null 2>&1

# -q to quiet the git summary output
# the complicated message format is to allow us to post both a summary (the compile command used)
# and an extended description (the compiler feedback to the user)
# To create a multi-line message, we use http://stackoverflow.com/questions/5064563/add-line-break-to-git-commit-m-from-command-line
git commit -q -F- << EOF > /dev/null 2>&1
gcc $@

$RESULT

EOF

git push origin master > /dev/null 2>&1

# display the compiler output to the user
echo "$RESULT"
