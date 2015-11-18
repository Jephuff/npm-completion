_npm_completion () {
  CUR=${COMP_WORDS[COMP_CWORD]}
  if [ $3 = "install" -o $3 = "i" ]; then
    COMPREPLY=( $( grep "^$CUR" "$PATH_TO_NPM_COMPLETION/keys/npm-all" ) )
  elif [ $3 = "update" -o $3 = "remove" -o $3 = "rm" -o $3 = "r" -o $3 = "un" -o $3 = "unlink" -o $3 = "uninstall" ]; then
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
