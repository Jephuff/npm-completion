type complete > /dev/null >> /dev/null
HAS_COMPLETE_FUNC=$?

_npm_completion_existing() {
  if [ $? = 0 ]; then # is global
    _npm_completion_existing_global
  else
    _npm_completion_existing_local
  fi
}

_npm_completion () {
  _npm_completion_setup

  CUR=${COMP_WORDS[COMP_CWORD]}

  IDX=$(expr $COMP_CWORD - 1)
  CMD=${COMP_WORDS[IDX]}
  OPT=$CMD
  while [ "${CMD:0:1}" = "-" ]; do
    IDX=$(expr $IDX - 1)
    CMD=${COMP_WORDS[IDX]}
  done

  DO_DEFAULT=true

  if [ "$CMD" = "install" -o "$CMD" = "i" ]; then
    _npm_completion_install
  elif [ "$CMD" = "remove" -o "$CMD" = "rm" -o "$CMD" = "r" -o "$CMD" = "un" -o "$CMD" = "unlink" -o "$CMD" = "uninstall" ]; then
    echo "${COMP_WORDS[@]}" | grep '\s-g\([^\w]\|$\)' > /dev/null 2>/dev/null
    _npm_completion_existing
  elif [ "$CMD" = "run" ]; then
    _npm_completion_package_data scripts
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
    IFS=$'\n' COMPREPLY=($(COMP_CWORD=$COMP_CWORD \
                 COMP_LINE=$COMP_LINE \
                 COMP_POINT=$COMP_POINT \
                 npm completion -- "${COMP_WORDS[@]}" 2> /dev/null \
                 | grep "^$CUR" 2> /dev/null)) || return $?
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
