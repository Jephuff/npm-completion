#!/bin/sh

# find user
user=$(whoami | sed 's/.*[\/\\]//')
if [ $user = "root" ]; then
  user=$( who am i 2> /dev/null | awk '{print $1}')
fi
USER_HOME=$(eval echo ~$user)
# check for source files
if [ -e $USER_HOME/.bashrc ]; then
  echo "$USER_HOME/.bashrc"
elif [ -e $USER_HOME/.bash_profile ]; then
  echo "$USER_HOME/.bash_profile"
fi

if [ -e $USER_HOME/.zshrc ]; then
  echo "$USER_HOME/.zshrc"
fi
