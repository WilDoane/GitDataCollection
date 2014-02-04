# An instrumentation of the gcc compiler command to push to a GitHub repository

# Getting the actual path to GCC
if ( -e /usr/gcc ) set gcccompiler = /usr/gcc
if ( -e /usr/bin/gcc ) set gcccompiler = /usr/bin/gcc
if ( -e /usr/local/gcc ) set gcccompiler = /usr/local/gcc
if ( -e /usr/local/bin/gcc ) set gcccompiler = /usr/local/bin/gcc

# Creating a temporary file to store compiler output
set tempfile = `mktemp`

set compileTimePath = `git rev-parse --show-prefix`

# Constructing the gcc compiler call from command-line arguments
set compilerCall = ""
set x = "0"

foreach x ($argv)
  set compilerCall = "$compilerCall $x"
end

# Compiling the code and sinking gcc messages (stderr) to a file
($gcccompiler $compilerCall) >&! $tempfile

# add modified AND new files to the index
git add . >& /dev/null

# add deleted files to the index
git add -u >& /dev/null

# -q to quiet the git summary output
# the complicated message format is to allow us to post both a summary (the compile command used)
# and an extended description (the compiler feedback to the user)
# To create a multi-line message, we use http://stackoverflow.com/questions/5064563/add-line-break-to-git-commit-m-from-command-line
git commit -q -F- << EOF >& /dev/null
cd $compileTimePath
gcc $compilerCall

`cat $tempfile`

EOF

# push the repository to a remote Github repo
# and suppress console output
git push origin master >& /dev/null

# send compiler output to the console
cat $tempfile

# remove the temp file
/bin/rm -f $tempfile
