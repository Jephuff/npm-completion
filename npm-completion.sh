type complete > /dev/null 2> /dev/null
HAS_COMPLETE_FUNC=$?

type compdef > /dev/null 2> /dev/null
HAS_COMPDEF_FUNC=$?

_npm_completion_install() {
  DO_DEFAULT=false
  COMPREPLY=( $( grep "^$CUR" "$NPM_BIN/npm-completion/npm-package-names/npm-all" 2> /dev/null ) "${COMPREPLY[@]}")
}

_npm_completion_existing_global() {
  if [ ! -z $NPM_BIN ]; then
    DO_DEFAULT=false
    pushd $NPM_BIN >/dev/null
    COMPREPLY=( $( ls | grep "^$CUR" 2> /dev/null | sed "s/[^a-zA-Z0-9\-]$//" ) "${COMPREPLY[@]}")
    popd >/dev/null
  fi
}

_npm_completion_existing_local() {
  DO_DEFAULT=false
  DIR=$(pwd)

  while [ ! -d node_modules -a $(pwd) != "/" ]; do
    cd ../
  done

  if [ -d node_modules ]; then
    cd node_modules
    COMPREPLY=( $( ls | grep "^$CUR" 2> /dev/null | sed "s/[^a-zA-Z0-9\-]$//" ) "${COMPREPLY[@]}")
  fi

  cd $DIR
}


_get_npm_completion_package_data() {
  DIR=$(pwd)

  while [ ! -e package.json -a $(pwd) != "/" ]; do
    cd ../
  done

  if [ -e package.json ]; then
    $PATH_TO_NPM_COMPLETION/get-package-data.js $(pwd) $1
  fi

  cd $DIR
}

_npm_completion_package_data() {
  DO_DEFAULT=false
  COMPREPLY=($(_get_npm_completion_package_data $1 | grep "^$CUR" 2> /dev/null) "${COMPREPLY[@]}")
}

uname | grep "MINGW[0-9][0-9]_NT" > /dev/null
if [ $? = 0 ]; then
  IS_WINDOWS="true"
fi

_npm_completion_setup() {
  if [ x${words+set} = xset ]; then
    COMP_WORDS=("${words[@]}")
  fi

  if [ x${CURRENT+set} = xset ]; then
    COMP_CWORD=$CURRENT
  fi

  if [ "$IS_WINDOWS" = "true" ]; then
    HOME_DIR=~
    NPM_BIN=$HOME_DIR"/AppData/Roaming/npm/node_modules"
  else
    NPM_BIN="$(which npm)"
    while [ -h $NPM_BIN ]; do
      NPM_BIN=$(dirname $NPM_BIN)/$(ls -ld -- "$NPM_BIN" | awk '{print $11}')
    done
    NPM_BIN=$(echo $NPM_BIN | sed 's/[\\\/]npm[\\\/]bin.*//')
  fi

  COMPREPLY=()
}

. "$PATH_TO_NPM_COMPLETION"/completions/npm.sh

if [ "$INCLUDE_YARN_COMPLETION" != "false" ]; then
  . "$PATH_TO_NPM_COMPLETION"/completions/yarn.sh
fi

