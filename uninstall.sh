#!/bin/bash
npm_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -e ~/.bashrc ]; then
	source_file=".bashrc"
elif [ -e ~/.bash_profile ]; then
	source_file=".bash_profile"
fi

if [ ! -z $source_file ]; then
	bash_comment="# added for npm-completion"
	bash_variable="PATH_TO_NPM_COMPLETION"
	npm_source=". \$PATH_TO_NPM_COMPLETION\/npm-completion.sh"

	sed -i "/$bash_comment/d" ~/$source_file
	sed -i "/$bash_variable/d" ~/$source_file
	sed -i "/$npm_source/d" ~/$source_file
fi

echo "remove this line to a cron job or startup script if added"
echo "    cd $npm_path && ./update.sh"
