# ===============================
# Gruvbox Minimal — two-line, clean
# ===============================
setopt PROMPT_SUBST

_gruvbox_user() {
  [[ $UID -eq 0 ]] && echo "%F{167}root%f" || echo "%F{142}%n%f"
}

_gruvbox_git_info() {
  local ref git_root depth=0 current dirty_color
  ref=$(git symbolic-ref HEAD 2>/dev/null) || ref=$(git rev-parse --short HEAD 2>/dev/null) || return
  git_root=$(git rev-parse --show-toplevel 2>/dev/null) || return
  current=$PWD
  while [[ "$current" != "$git_root" && "$current" != "/" ]]; do
    current=${current:h}
    ((depth++))
  done
  if git diff --quiet HEAD 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
    dirty_color="%F{108}"
  else
    dirty_color="%F{208}"
  fi
  echo " %F{109}on%f %F{214} ${ref#refs/heads/}%f ${dirty_color}${depth}%f"
}

PROMPT='
%F{246}┌─%f$(_gruvbox_user)%F{246}@%f%F{109}%m%f  %F{214}%~%f$(_gruvbox_git_info)
%F{246}└─%F{108}$%f '

PROMPT2="%F{208}  $%f "

RPROMPT="%(?..%F{167}✘ %?%f)"
