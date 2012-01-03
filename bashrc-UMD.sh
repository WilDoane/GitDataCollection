###########################################################################
###########################################################################
#####
#####		PROJECT GLUE SHELL INITIALIZATION FILE
#####
###########################################################################
#####
#####			DO NOT EDIT THIS FILE!  
#####
###########################################################################
###########################################################################

###  $Id: functions.m4,v 1.24 2008/04/29 14:33:15 kevin Exp $  #### Only bash understands set -o.  For simplicity I'll just redirect it to
# /dev/null so that the other bourne shells don't complain.
  
###  $Id: files.m4,v 1.20 2008/04/14 14:13:01 sturdiva Exp $  ###
###  $Id: skel.shellrc.m4,v 1.5 2005/10/17 21:25:50 sturdiva Exp $  ###

# WARNING: the systems staff will periodically make changes
# to this file, and any local changes you have made will be lost.

# This file sources a system-wide bashrc file, which:
# 	- sets up standard environment variables
# 	- sources user file ~/.bash_environment , if it exists
# 	- sets standard path, OR sources user file ~/.bash_path, if it exists
# 	- sets up standard shell variables, aliases, etc...
# 	- source user file ~/.bashrc.mine, if it exists
# 	- source user file ~/.bash_aliases, if it exists

# If you want to ADJUST the shell initialization sequence, create any
# of the following files (as appropriate) in your home directory, with
# to achieve the effect listed: 
# 
# 	~/.bash_environment 	- set, change, or unset environment variables
# 	~/.bash_path 	- set default search path (you can refer to
# 			  shell variable $glue_path, which lists the 
# 			  glue default path, when you set path, e.g.,
# 			  PATH=".:$glue_path:~/foobar"
# 	~/.bash_aliases 	- setup, change or unset shell aliases
# 	~/.bashrc.mine 	- setup shell environment (set shell 
# 			  variables, unset system defaults, etc...)

# WARNING: the systems staff will periodically make changes
# to this file, and any local changes you have made will be lost.

initdir="/local/lib/init"

if [ -r $initdir/bashrc ]; then
    . $initdir/bashrc
else 
    if [ ! "x$prompt" = "x" ]; then	# Do not echo if non-interactive
	echo "Warning: System-wide initialization files not found."
	echo "Warning: Shell initialization has not been performed."
	stty dec
    fi
    # Set some basic defaults if we failed
    umask 022
    PATH="/usr/local/scripts:/usr/local/bin:/usr/bin:/usr/afsws/bin:."; export PATH

fi
