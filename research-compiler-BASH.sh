# An instrumentation of the gcc compiler command to push to a GitHub repository

# where is the real gcc located? to find out, type at the command prompt
#   which gcc

GCC=/usr/local/bin/gcc

# run gcc with the full list of arguments from the CLI ($@), 
# capturing STDERR (2) to STDOUT (&1)
# and store the STDOUT (i.e., the compiler output) in the variable RESULT
RESULT=$($GCC $@ 2>&1)

# add modified AND new files to the index
git add .

# -q to quiet the git summary output
# the complicated message format is to allow us to post both a summary (the compile command used)
# and an extended description (the compiler feedback to the user)
git commit -q -m "$(echo "$GCC $@\n\n$RESULT")" 

#git push

# display the compiler output to the user
echo "\n$RESULT"
