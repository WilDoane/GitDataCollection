#!/usr/bin/tcsh

if ( "$1" == "" ) then
  echo ""
  echo "     USAGE: ./setup.sh [PrivateRepoName]"
  echo "        ex: ./setup.sh SamSpade"
  echo "which adds: git remote add origin git@github.com:TLPLEngineeringEdResearch/SamSpade.git"
  echo ""
  exit
endif

# Download the appropriate compiler for the user's shell
if ( "$SHELL" =~ *tcsh* ) then
  # tcsh version (UMD default shell)
  curl -k https://raw.github.com/WilDoane/GitDataCollection/master/research-compiler-tcsh.sh -o ~/research-compiler.sh
  echo 'alias gcc "~/research-compiler.sh"' >> ~/.aliases
  source ~/.aliases
else if ( "$SHELL" =~ *bash ) then
  curl -k https://raw.github.com/WilDoane/GitDataCollection/master/research-compiler-BASH.sh -o ~/research-compiler.sh
  echo 'alias gcc="~/research-compiler.sh"' >> ~/.bash_aliases
  source ~/.bash_aliases
else
  echo "this user's shell isn't TCSH or BASH"
  echo "no setup was performed"
  exit
endif


# Make the research compiler executable
chmod 700 ~/research-compiler.sh

cd ~
if ( -d ~/ENEE150 ) then
  echo "The user already has an ENEE150 directory..."
  echo "   using existing directory"
else
  mkdir ENEE150  
endif

cd ENEE150

git init
touch .gitignore
printf "\n*.out\n" >> .gitignore

git remote add origin git@github.com:TLPLEngineeringEdResearch/$1.git

cd ~
if ( -d ~/.ssh ) then
  echo "The user already has an SSH key..."
  echo "   check out the ~/.ssh directory and instructions from http://help.github.com/linux-set-up-git/"
  exit
else
  echo "Now you should"
  echo '  git config --global user.name "Students Name"'
  echo '  git config --global user.email "student_email@youremail.com"'
  echo '  ssh-keygen -t rsa -C "student_email@youremail.com"'
  echo "and accept the default storage directory and enter a blank password"
  echo "then, "
  echo "  cat ~/.ssh/id_rsa.pub"
  echo "and copy and paste it to GitHub's key list"
endif
  