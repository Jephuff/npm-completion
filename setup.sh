#!/bin/bash
npm_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -e ~/.bashrc ]; then
	source_file=".bashrc"
elif [ -e ~/.bash_profile ]; then
	source_file=".bash_profile"
fi

if [ ! -z $source_file ]; then
	bash_comment="# added for npm-completion https://github.com/Jephuff/npm-bash-completion"
	bash_variable="PATH_TO_NPM_COMPLETION=\"$npm_path\""
	npm_source=". \$PATH_TO_NPM_COMPLETION/npm-completion.sh"

	grep -F "$bash_comment" ~/$source_file > /dev/null
	if [ $? != 0 ]; then
		printf "\n$bash_comment" >> ~/$source_file
	fi

	grep -F "$bash_variable" ~/$source_file > /dev/null
	if [ $? != 0 ]; then
		printf "\n$bash_variable" >> ~/$source_file
	fi

	grep -F "$npm_source" ~/$source_file > /dev/null
	if [ $? != 0 ]; then
		printf "\n$npm_source" >> ~/$source_file
	fi
fi

echo "add this line to a cron job or startup script"
echo "    cd $npm_path && $(which git) pull"
