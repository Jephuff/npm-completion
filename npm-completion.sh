type complete > /dev/null >> /dev/null
HAS_COMPLETE_FUNC=$?

_npm_completion () {
  if [ x${words+set} = xset ]; then
    COMP_WORDS=("${words[@]}")
  fi

  if [ x${CURRENT+set} = xset ]; then
    COMP_CWORD=$CURRENT
  fi

  CUR=${COMP_WORDS[COMP_CWORD]}

  IDX=$(expr $COMP_CWORD - 1)
  CMD=${COMP_WORDS[IDX]}
  while [ "${CMD:0:1}" = "-"  ]; do
    IDX=$(expr $IDX - 1)
    CMD=${COMP_WORDS[IDX]}
  done

  uname | grep "MINGW[0-9][0-9]_NT" > /dev/null
  if [ $? = 0 ]; then
    HOME_DIR=~
    NPM_BIN=$HOME_DIR"/AppData/Roaming/npm/node_modules"
  else
    NPM_BIN="$(which npm)"
    while [ -h $NPM_BIN ]; do
      NPM_BIN=$(dirname $NPM_BIN)/$(ls -ld -- "$NPM_BIN" | awk '{print $11}')
    done
    NPM_BIN=$(echo $NPM_BIN | sed 's/[\\\/]npm[\\\/]bin.*//')
  fi

  DO_DEFAULT=true
  if [ "$CMD" = "install" -o "$CMD" = "i" ]; then
    DO_DEFAULT=false
    COMPREPLY=( $( grep "^$CUR" "$NPM_BIN/npm-completion/npm-package-names/npm-all" 2> /dev/null ) )
  elif [ "$CMD" = "update" -o "$CMD" = "remove" -o "$CMD" = "rm" -o "$CMD" = "r" -o "$CMD" = "un" -o "$CMD" = "unlink" -o "$CMD" = "uninstall" ]; then
    echo "${COMP_WORDS[@]}" | grep '\s-g\([^\w]\|$\)' > /dev/null 2>/dev/null
    if [ $? = 0 ]; then # is global
      if [ ! -z $NPM_BIN ]; then
        DO_DEFAULT=false
        pushd $NPM_BIN >/dev/null
        COMPREPLY=( $( ls | grep "^$CUR" 2> /dev/null | sed "s/[^a-zA-Z0-9\-]$//" ) )
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
        COMPREPLY=( $( ls | grep "^$CUR" 2> /dev/null | sed "s/[^a-zA-Z0-9\-]$//" ) )
      else
        COMPREPLY=()
      fi

      cd $DIR
    fi
  fi

  if [ $DO_DEFAULT = true ]; then
    if [ x${BUFFER+set} = xset ]; then
      COMP_LINE=$BUFFER
    fi

    if [ x${COMP_POINT} != xset ]; then
      COMP_POINT=0
    fi

    if [ x${CURRENT+set} = xset ]; then
      COMP_CWORD=$( expr $CURRENT - 1)
    fi

    si="$IFS"
    IFS=$'\n'
    COMPREPLY=($(COMP_CWORD=$COMP_CWORD \
                 COMP_LINE=$COMP_LINE \
                 COMP_POINT=$COMP_POINT \
                 npm completion -- "${COMP_WORDS[@]}" \
                 2>/dev/null))
    IFS="$si"
  fi

  if [ $HAS_COMPLETE_FUNC != 0 ]; then
    compadd $COMPREPLY
  fi
}

if [ $HAS_COMPLETE_FUNC = 0 ]; then
  complete -F _npm_completion npm
else
  compdef _npm_completion npm
fi
