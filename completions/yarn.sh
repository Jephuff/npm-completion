type complete > /dev/null >> /dev/null
HAS_COMPLETE_FUNC=$?

# TODO: most commands support --cache-folder?
# TODO: --registry=<registry url>.?
_NPM_COMPLETION_YARN_SUB_yarn="add bin cache check clean config create generate-lock-entry global help import info init install licenses link login logout list outdated owner pack publish remove run tag team test unlink upgrade upgrade-interactive version versions why" # TODO: self-update

_NPM_COMPLETION_YARN_FLAGS_add="--dev -D --peer -P --optional -O --exact -E --tilde -T"

# bin

_NPM_COMPLETION_YARN_SUB_cache="ls dir clean"

_NPM_COMPLETION_YARN_FLAGS_check="--integrity"

# clean

_NPM_COMPLETION_YARN_SUB_config="set get delete list"
_NPM_COMPLETION_YARN_FLAGS_config="-g --global"

# create

# generate-lock-entry

_NPM_COMPLETION_YARN_SUB_global="add bin ls remove upgrade"
_NPM_COMPLETION_YARN_FLAGS_global="--prefix"

# help

# import

_NPM_COMPLETION_YARN_FLAGS_info="--json"

_NPM_COMPLETION_YARN_FLAGS_init="-y --yes"

_NPM_COMPLETION_YARN_FLAGS_install="--check-files --flat --force --har --ignore-scripts --modules-folder --no-lockfile --production --pure-lockfile --ignore-engines --offline"


_NPM_COMPLETION_YARN_SUB_licenses="generate-disclaimer ls"

# link

# login

# logout

_NPM_COMPLETION_YARN_FLAGS_list="--depth"

# outdated

_NPM_COMPLETION_YARN_SUB_owner="ls add rm"

_NPM_COMPLETION_YARN_FLAGS_pack="--filename"

_NPM_COMPLETION_YARN_FLAGS_publish="--tag --access"

_NPM_COMPLETION_YARN_FLAGS_remove="$_NPM_COMPLETION_YARN_FLAGS_install"

# run

# self-update

_NPM_COMPLETION_YARN_SUB_tag="add rm ls"

_NPM_COMPLETION_YARN_SUB_team="create destroy add rm ls" #TODO: scope/users

# test

# unlink

# upgrade

_NPM_COMPLETION_YARN_FLAGS_upgrade_interactive="--tilde -T --exact -E"

_NPM_COMPLETION_YARN_FLAGS_version="--no-git-tag-version --new-version"

# versions

# why

_npm_completion_flags() {
  VARNAME=_NPM_COMPLETION_YARN_FLAGS_$(echo $CMD | sed s/-/_/)
  ARR=${!VARNAME}
  ADD_TO_COMPREPLY=( $( compgen -W "$ARR" -- "$CUR" ) )

  EXISTING_TEMP=()

  for value in "${ADD_TO_COMPREPLY[@]}"; do
    found=false
    for existing in "${COMP_WORDS[@]}"; do
      if [ "$existing" == "$value" -a "$existing" != "$CUR" ]; then
        found=true
      fi
    done

    if [ $found != true ]; then
      EXISTING_TEMP+=($value)
    fi
  done

  COMPREPLY=( "${EXISTING_TEMP[@]}" "${COMPREPLY[@]}")
}

_npm_completion_sub() {
  if [ "$SUB_CMD" == "" ]; then
    VARNAME=_NPM_COMPLETION_YARN_SUB_$(echo $CMD | sed s/-/_/)
    ARR=${!VARNAME}
    COMPREPLY=( $( compgen -W "$ARR" -- "$CUR" ) "${COMPREPLY[@]}")
  fi
}

_yarn_completion() {
  _npm_completion_setup

  SUB_CMD=""

  CMD=${COMP_WORDS[1]}
  if [ $(expr $COMP_CWORD) -gt 2 ]; then
    SUB_CMD=${COMP_WORDS[2]}
  fi

  IDX=$(expr $COMP_CWORD - 1)
  LAST=${COMP_WORDS[IDX]}

  CUR=${COMP_WORDS[COMP_CWORD]}

  if [ $(expr $COMP_CWORD) == 1 ]; then
    CMD="yarn"
    _npm_completion_sub
    _npm_completion_package_data scripts
  elif [ "$CMD" = "add" ]; then
    _npm_completion_flags
    _npm_completion_install
  elif [ "$CMD" = "info" ]; then
    flags=0
    for value in "${COMP_WORDS[@]}"; do
      if [ "$value" == "--json" ]; then
        flags=1
      fi
    done

    if [ $(expr $COMP_CWORD) == $(expr $flags + 2) ]; then
      _npm_completion_install
    elif [ $(expr $COMP_CWORD) == $(expr $flags + 3) ]; then
      _npm_completion_package_data
    fi

    _npm_completion_flags
  elif [ "$CMD" = "upgrade" ]; then
    _npm_completion_existing_local
  elif [ "$CMD" = "outdated" ]; then
    _npm_completion_package_data dependencies,devDependencies,optionalDependencies
  elif [ "$CMD" = "run" ]; then
    if [ $(expr $COMP_CWORD) == 2 ]; then
      _npm_completion_package_data scripts
    fi
  elif [ "$CMD" = "create" ]; then
    prefix=create-
    CUR=$prefix$CUR
    _npm_completion_install
    COMPREPLY=(${COMPREPLY[@]/$prefix})
  elif [ "$CMD" = "init" ]; then
    _npm_completion_flags
  elif [ "$CMD" = "install" -o "$CMD" = "remove" ]; then
    if [ "$LAST" = "--modules-folder" ]; then
      _longopt
    elif [ "$LAST" = "--production" ]; then
      COMPREPLY=( $( compgen -W "true false" -- "$CUR" ) )
    else
      _npm_completion_flags
    fi
  elif [ "$CMD" = "link" -o "$CMD" = "unlink" ] && [ $(expr $COMP_CWORD) = 2 ]; then
    COMPREPLY=( $( compgen -W "$(ls ~/.yarn-config/link && ls ~/.config/yarn/link/)" -- "$CUR" ) )
  elif [ "$CMD" = "publish" ]; then
    if [ "$LAST" = "--access" ]; then
      COMPREPLY=( $( compgen -W "public restricted" -- "$CUR" ) )
    elif [ "$LAST" != "--tag" ]; then
      _longopt # TODO: prevent multiple files
      _npm_completion_flags
    fi
  elif [ "$CMD" = "version" ]; then
    if [ "$LAST" != "--new-version" ]; then
      _npm_completion_flags
    fi
  elif [ "$CMD" = "why" ]; then
    _longopt
    _npm_completion_existing_local
  elif [ $(expr $COMP_CWORD) == 2 ]; then
    _npm_completion_sub
    if [ "$COMPREPLY" = "" ]; then
      _npm_completion_flags
    fi
  elif [ "$CMD" = "config" ]; then
    if [ "$SUB_CMD" = "get" -o "$SUB_CMD" = "delete" ]; then
      if [ $(expr $COMP_CWORD) == 3 ]; then
        COMPREPLY=( $( yarn config list | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | grep -o '[^ \{][^\{]*: ' | grep -o '^.*[^: ]' | grep -o "[^'].*[^']" | grep "^$CUR" 2> /dev/null ) )
      fi
    elif [ "$SUB_CMD" = "set" -a $(expr $COMP_CWORD) == 4 ]; then
      # TODO: find all possible config values?
      _npm_completion_flags
    fi
  elif [ "$CMD" = "owner" ]; then
    if [ "$SUB_CMD" = "ls" ]; then
      _npm_completion_install
    elif [ "$SUB_CMD" = "add" -o "$SUB_CMD" = "rm" ]; then
      if [ $(expr $COMP_CWORD) == 4 ]; then
        _npm_completion_install
      # TODO: handle users
      # elif [ $(expr $COMP_CWORD) == 3 ]; then
        # list users?
      fi
    fi
  elif [ "$CMD" = "global" ]; then
    if [ "$LAST" = "--prefix" ]; then
      _longopt
    elif [ "$LAST" = "--depth" ]; then
      :
    elif [ "$SUB_CMD" = "add" ]; then
      if [ $(expr $COMP_CWORD) == 3 ]; then
        _npm_completion_install
      elif [ $(expr $COMP_CWORD) == 4 ]; then
        _npm_completion_flags
      fi
    elif [ "$SUB_CMD" = "bin" ]; then
      _npm_completion_flags
    elif [ "$SUB_CMD" = "ls" ]; then
      COMPREPLY=( $( compgen -W "--depth" -- "$CUR" ) )
      _npm_completion_flags
    elif [ "$SUB_CMD" = "remove" ]; then
       # TODO: finish
      _npm_completion_existing_global
      _npm_completion_flags
    elif [ "$SUB_CMD" = "upgrade" ]; then
      _npm_completion_flags # TODO: finish
    fi
  elif [ "$CMD" = "pack" ]; then
    if [ "$LAST" = "--filename" ]; then
      _longopt
    fi
  elif [ "$CMD" = "tag" ]; then
    if [ $(expr $COMP_CWORD) == 3 ]; then
      _npm_completion_install # TODO: only your packages and versions?
    fi
  else
    _npm_completion_flags
    _npm_completion_sub
  fi

  if [ $HAS_COMPLETE_FUNC != 0 ]; then
    compadd $COMPREPLY
  fi
}

if [ $HAS_COMPLETE_FUNC = 0 ]; then
  complete -F _yarn_completion yarn
else
  compdef _yarn_completion yarn
fi
