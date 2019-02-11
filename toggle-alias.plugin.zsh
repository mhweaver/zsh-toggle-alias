function _find_git_aliases() {
  if [[ "$1" = "git "* ]]; then
      local k
      local v
      git config --get-regexp "^alias\..+$" | sort | while read k v; do
        k="${k#alias.}"
        if [[ "$1" = "git $v" || "$1" = "git $v "* ]]; then
          echo "git $k"
		  return 0
        fi
      done
  fi
}


function _find_global_aliases() {
  local tokens
  local k
  local v
  alias -g | sort | while read entry; do
    tokens=("${(@s/=/)entry}")
    k="${tokens[1]}"
    # Need to remove leading and trailing ' if they exist
    v="${(Q)tokens[2]}"

    if [[ "$1" = *"$v"* ]]; then
      echo "$k"
	  return 0
    fi
  done
}


function _find_aliases() {
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

  echo "$best_match"
  return 0
}

function collapse_alias() {
	local MATCH="$(_find_aliases $LBUFFER)"
	if [[ -z $MATCH ]]; then
		MATCH="$(_find_global_aliases $LBUFFER)"
	fi

	if [[ -n $MATCH ]]; then
		LBUFFER="$MATCH"
	else
		zle _expand_alias
		zle expand-word
	fi
}

zle -N collapse_alias
bindkey -M emacs "^ " collapse_alias
bindkey -M emacs " " magic-space
bindkey -M viins "^ " collapse_alias
bindkey -M viins " " magic-space