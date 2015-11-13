#!/bin/bash
npm_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bash_profile_entry="\n\
	# added for npm-completion https://github.com/Jephuff/npm-bash-completion\n\
	PATH_TO_NPM_COMPLETION=\"$npm_path\"\n\
	. \$PATH_TO_NPM_COMPLETION/npm-completion.sh\n"

if [ -e ~/.bashrc ]; then
	echo -e $bash_profile_entry >> ~/.bashrc
elif [ -e ~/.bash_profile ]; then
	echo -e $bash_profile_entry >> ~/.bash_profile
fi
