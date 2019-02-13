function _collapse_git_aliases() {
  if [[ "$1" = "git "* ]]; then
      local k
      local v
      git config --get-regexp "^alias\..+$" | sort | while read k v; do
        k="${k#alias.}"
        if [[ "$1" = "git $v" || "$1" = "git $v "* ]]; then
          echo "${1/"git ${v}"/"git ${k}"}"
		  return 0
        fi
      done
  fi
  echo "$1"
}


function _collapse_global_aliases() {
  local tokens
  local k
  local v
  alias -g | sort | while read entry; do
    tokens=("${(@s/=/)entry}")
    k="${tokens[1]}"
    # Need to remove leading and trailing ' if they exist
    v="${(Q)tokens[2]}"

    if [[ "$1" = *"$v"* ]]; then
      echo "${1/"${v}"/"${k}"}"
	  return 0
    fi
  done
  echo "$1"
}


function _toggle_aliases() {
  local found_aliases
  found_aliases=()
  local best_match=""
  local best_match_value=""
  local v

  # Find alias matches
  for k in "${(@k)aliases}"; do
    v="${aliases[$k]}"

    if [[ "$1" = "$v" || "$1" = "$v "* ]]; then

      # if the alias longer or the same length as its command
      # we assume that it is there to cater for typos.
      # If not, then the alias would not save any time
      # for the user and so doesn't hold much value anyway
      if [[ "${#v}" -gt "${#k}" ]]; then

        found_aliases+="$k"

        # Match aliases to longest portion of command
        if [[ "${#v}" -gt "${#best_match_value}" ]]; then
          best_match="$k"
          best_match_value="$v"
        # on equal length, choose the shortest alias
        elif [[ "${#v}" -eq "${#best_match}" && ${#k} -lt "${#best_match}" ]]; then
          best_match="$k"
          best_match_value="$v"
        fi
      fi
    fi
  done

  if [[ -z "$best_match" ]]; then
	  echo "$1"
  else
    echo "${1/"${best_match_value}"/"${best_match}"}"
  fi
  return 0
}

function _expand_aliases() {
  # https://unix.stackexchange.com/a/150737
  unset 'functions[_expand-aliases]'
  functions[_expand-aliases]=$BUFFER
  (($+functions[_expand-aliases])) &&
    BUFFER=${functions[_expand-aliases]#$'\t'} &&
    CURSOR=$#BUFFER
}

function _collapse_aliases() {
	local collapsed="$1"
	#if [[ "$collapsed" = "$1" ]]; then
	#	collapsed="$(_collapse_git_aliases $collapsed)"
	if [[ "$collapsed" == "$1" ]]; then
		collapsed="$(_toggle_aliases $collapsed)"
	elif [[ "$collapsed" = "$1" ]]; then
		collapsed="$(_collapse_global_aliases $collapsed)"
	fi
	echo "$collapsed"
}

function toggle_alias() {
	local MATCH="$(_collapse_aliases $BUFFER)"
	if [[ $BUFFER != $MATCH ]]; then
		BUFFER="$MATCH"
	else
		#zle _expand_alias
		#zle expand-word
		_expand_aliases
	fi
}

zle -N toggle_alias
bindkey -M emacs "^ " toggle_alias
bindkey -M emacs " " magic-space
bindkey -M viins "^ " toggle_alias
bindkey -M viins " " magic-space
