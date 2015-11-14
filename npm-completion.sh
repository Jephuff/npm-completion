_npm_completion () {
  CUR=${COMP_WORDS[COMP_CWORD]}
  FIRST_LETTER=$(echo $CUR | head -c 1)
  if [ $3 = "install" ] && [ ! -z $FIRST_LETTER ]; then
    COMPREPLY=( $( compgen -W "$(cat $PATH_TO_NPM_COMPLETION/keys/npm-$FIRST_LETTER)" -- $CUR ) )
  elif [ $3 = "remove" ]; then
    COMPREPLY=( $( compgen -W "$(ls ~/.npm 2>/dev/null)" -- $CUR ) )
  else
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  fi
}

complete -F _npm_completion npm
