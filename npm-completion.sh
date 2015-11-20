custom_readlink() { [ ! -h "$1" ] && echo "$1" || (local link="$(expr "$(command ls -ld -- "$1")" : '.*-> \(.*\)$')"; cd $(dirname $1); custom_readlink "$link" | sed "s|^\([^/].*\)\$|$(dirname $1)/\1|"); }
_npm_completion () {
  CUR=${COMP_WORDS[COMP_CWORD]}

  echo "${COMP_WORDS[@]}" | grep '\s-g\([^\w]\|$\)' > /dev/null 2>/dev/null
  GLOBAL=$?
  
  IDX=$(expr $COMP_CWORD - 1)
  CMD=${COMP_WORDS[IDX]}
  while [ "${CMD:0:1}" == "-"  ]; do
    IDX=$(expr $IDX - 1)
    CMD=${COMP_WORDS[IDX]}
  done

  uname | grep "MINGW[0-9][0-9]_NT" > /dev/null
  if [ $? = 0 ]; then
    user=$(who am i 2> /dev/null) 
    if [ -z "$user" ]; then
      user=$(whoami)
    fi
    user=$( echo "$user" | awk '{print $1}' | sed 's/.*[\/\\]//')
    NPM_BIN="/c/Users/$user/AppData/Roaming/npm/node_modules"
  else
    NPM="$(which npm)"
    NPM_BIN=$(echo "$(dirname "$(custom_readlink "$NPM")")" | sed 's/[\\\/]npm[\\\/]bin.*//')
  fi

  DO_DEFAULT=true
  if [ $CMD = "install" -o $CMD = "i" ]; then
    DO_DEFAULT=false
    COMPREPLY=( $( grep "^$CUR" "$PATH_TO_NPM_COMPLETION/keys/npm-all" ) )
  elif [ $CMD = "update" -o $CMD = "remove" -o $CMD = "rm" -o $CMD = "r" -o $CMD = "un" -o $CMD = "unlink" -o $CMD = "uninstall" ]; then
    if [ $GLOBAL = 0 ]; then
      if [ ! -z $NPM_BIN ]; then
        DO_DEFAULT=false
        pushd $NPM_BIN >/dev/null
        COMPREPLY=( $( compgen -d -- $CUR | sed 's/\(^\| \).bin\( \|$\)/ /') )
        popd >/dev/null
      fi
    else
      DO_DEFAULT=false
      DIR=$(pwd)

      while [ ! -d node_modules -a $(pwd) != "/" ]; do
        cd ../
      done

      if [ -d node_modules ]; then
        cd node_modules
        COMPREPLY=( $( compgen -d -- $CUR | sed 's/\(^\| \).bin\( \|$\)/ /') )
      fi

      cd $DIR
    fi
  fi

  if [ $DO_DEFAULT = true ]; then
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" COMP_LINE="$COMP_LINE" COMP_POINT="$COMP_POINT" npm completion -- "${COMP_WORDS[@]}" 2>/dev/null)) || return $?
    IFS="$si"
  fi
}

complete -F _npm_completion npm