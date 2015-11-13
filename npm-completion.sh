_npm_completion () {
  CUR=${COMP_WORDS[COMP_CWORD]}
  if [ $3 = "i" -o $3 = "install" ]; then
    COMPREPLY=( $( compgen -W "$(cat "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/keys/npm-$(echo $CUR | head -c 1))" -- $CUR ) )
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
