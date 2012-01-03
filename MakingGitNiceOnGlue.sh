git config --global color.ui auto 	# too new for glue
git config --global color.diff auto
git config --global color.branch auto
git config --global color.interactive auto
git config --global color.status auto

# Makes the pager render the color escape codes sent by git
setenv PAGER "less -r"

# The above is for tcsh, which is the default shell on glue.
# For /bin/sh-style shells (like bash and zsh), use this:
export PAGER="less -r"