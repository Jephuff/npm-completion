#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
if [ -d .git ]; then
	git pull
else
	npm update -g npm-completion
fi
