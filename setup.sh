#!/bin/tcsh

if ( "$1" == "" ) then
  echo ""
  echo "     USAGE: ./setup.sh [PrivateRepoName]"
  echo "        ex: ./setup.sh SamSpade"
  echo "which adds: git remote add origin git@github.com:TLPLEngineeringEdResearch/SamSpade.git"
  echo ""
  exit;
endif

curl -k https://raw.github.com/WilDoane/GitDataCollection/master/research-compiler-$SHELL.sh -o ~/research-compiler.sh

chmod 700 ~/research-compiler.sh

if ( "$SHELL" =~ *tcsh* ) then
  # tcsh version (UMD default shell)
  echo 'alias gcc "~/research-compiler.sh"' >> ~/.aliases
  source ~/.aliases
else if ( "$SHELL" =~ *bash ) then
  echo 'alias gcc="~/research-compiler.sh"' >> ~/.bash_aliases
  source ~/.bash_aliases
else
  echo "this user's shell isn't TCSH or BASH"
  echo "no setup was performed"
  exit;
endif

cd ~
mkdir ENEE150
cd ENEE150

git init
printf "\n*.out\n" >> .gitignore

git remote add origin git@github.com:TLPLEngineeringEdResearch/$1.git
