# ===============================
# Enable command substitution
# ===============================
setopt PROMPT_SUBST

# ===============================
# Fish-style collapsed path
# ===============================
_fishy_collapsed_wd() {
  local i pwd
  pwd=("${(s:/:)PWD/#$HOME/~}")

  if (( $#pwd > 1 )); then
    for i in {1..$(($#pwd-1))}; do
      if [[ "$pwd[$i]" = .* ]]; then
        pwd[$i]="${${pwd[$i]}[1,2]}"
      else
        pwd[$i]="${${pwd[$i]}[1]}"
      fi
    done
  fi

  echo "${(j:/:)pwd}"
}

# ===============================
# Git repo depth (.N)
# ===============================
_git_repo_depth() {
  local root cwd relpath parts

  root=$(git rev-parse --show-toplevel 2>/dev/null) || return
  cwd=$PWD
  relpath=${cwd#$root/}

  [[ "$relpath" = "$cwd" ]] && return

  parts=("${(s:/:)relpath}")
  echo ".${#parts}"
}

# ===============================
# Gruvbox colors
# ===============================
local gb_fg="#ebdbb2"
local gb_gray="#928374"
local gb_red="#fb4934"
local gb_green="#b8bb26"
local gb_yellow="#fabd2f"
local gb_blue="#83a598"
local gb_purple="#d3869b"
local gb_aqua="#8ec07c"
local gb_orange="#fe8019"

local user_color="$gb_green"
[[ $UID -eq 0 ]] && user_color="$gb_red"

# ===============================
# Git prompt config oh-my-zsh
# ===============================
ZSH_THEME_GIT_PROMPT_PREFIX=" %B%F{$gb_orange} %F{$gb_yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f%b "
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# ===============================
# LEFT PROMPT
# bold path + depth + branch + symbol
# ===============================
PROMPT='%B%F{$user_color}$(_fishy_collapsed_wd)%f%b \
%B%F{$gb_aqua}$(_git_repo_depth)%f%b\
%B%F{$gb_yellow}$(git_prompt_info)%f%b\
%B%F{$gb_fg}%(!.#. )%f%b '

# ===============================
# CONTINUATION PROMPT
# ===============================
PROMPT2='%B%F{$gb_red}\ %f%b'

# ===============================
# RIGHT PROMPT
# exit status only
# ===============================
local return_status="%B%F{$gb_red}%(?..%?)%f%b"
RPROMPT='${return_status}'
