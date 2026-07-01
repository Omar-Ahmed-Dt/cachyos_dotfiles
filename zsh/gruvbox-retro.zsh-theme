# ===============================
# Gruvbox Retro — bold block style
# ===============================
setopt PROMPT_SUBST

ZSH_THEME_GIT_PROMPT_PREFIX="%F{246}[%f%F{214}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f%F{246}]%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{208}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{108}=%f"

_gruvbox_retro_host() {
  [[ $UID -eq 0 ]] && echo "%F{167}%m%f" || echo "%F{142}%m%f"
}

_gruvbox_retro_pwd() {
  # Bold yellow for full path, truncate at 4 components
  echo "%F{214}%4~%f"
}

# ┌[ user@host ]─[ ~/path ]─[ branch ]
# └▶
PROMPT='%F{246}┌%f%F{246}[%f%F{109}%n%F{246}@%f$(_gruvbox_retro_host)%F{246}]%f%F{246}─%f%F{246}[%f$(_gruvbox_retro_pwd)%F{246}]%f$(git_prompt_info)
%F{246}└%f%F{208}▶%f '

PROMPT2="%F{208}  ▶%f "

RPROMPT="%(?..%F{167}[%?]%f) %F{246}%D{%H:%M:%S}%f"
