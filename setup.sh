#!/bin/bash
bash_profile_entry="\n# added for npm-completion https://github.com/Jephuff/npm-bash-completion\n"
bash_profile_entry=$bash_profile_entry". $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/npm-completion.sh"

if [ -e ~/.bashrc ]; then
	echo -e $bash_profile_entry >> ~/.bashrc
elif [ -e ~/.bash_profile ]; then
	echo -e $bash_profile_entry >> ~/.bash_profile
fi
