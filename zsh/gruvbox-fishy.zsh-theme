# ===============================
# Gruvbox Fishy — fishy layout, gruvbox palette
# ===============================
setopt PROMPT_SUBST

# Gruvbox 256-color codes
local gb_green="%F{142}"    # #b8bb26
local gb_red="%F{167}"      # #fb4934
local gb_yellow="%F{214}"   # #fabd2f
local gb_blue="%F{109}"     # #83a598
local gb_aqua="%F{108}"     # #8ec07c
local gb_orange="%F{208}"   # #fe8019
local gb_fg="%F{223}"       # #ebdbb2
local gb_gray="%F{246}"     # #a89984
local reset="%f"

# Fish-style collapsed path
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

# Git repo depth indicator
_git_repo_depth() {
  local root cwd relpath parts
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return
  cwd=$PWD
  relpath=${cwd#$root/}
  [[ "$relpath" = "$cwd" ]] && return
  parts=("${(s:/:)relpath}")
  echo ".${#parts}"
}

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" ${gb_orange}✦${reset}"
ZSH_THEME_GIT_PROMPT_CLEAN=" ${gb_aqua}✔${reset}"

local user_col=$gb_green
[[ $UID -eq 0 ]] && user_col=$gb_red

PROMPT='${user_col}$(_fishy_collapsed_wd)${reset} \
${gb_aqua}$(_git_repo_depth)${reset}\
${gb_yellow}$(git_prompt_info)${reset}\
%(!.#.$) '

PROMPT2="${gb_orange}\ ${reset}"

RPROMPT="%(?..${gb_red}%?${reset})"
