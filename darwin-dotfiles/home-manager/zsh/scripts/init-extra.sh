if [ -n "$TTY" ]; then
  export GPG_TTY=$(tty)
fi

gpgconf --launch gpg-agent
bindkey -e

# Completion settings
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# fzf-tab previews
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'cat $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

zle_highlight+=(paste:none)

# History settings
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

# Kubectl completion
if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
  compdef _kubectl k
fi

# Kubectl context helper function
function kctx() {
  local context=$(kubectl config current-context 2>/dev/null)
  local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
  if [[ -n $context ]]; then
    echo "☸️  $context${namespace:+:$namespace}"
  else
    echo "No kubectl context found"
  fi
}

# Show kubectl context before kubectl commands
function preexec_kubectl() {
  if [[ $1 == k* ]] || [[ $1 == kubectl* ]]; then
    local context=$(kubectl config current-context 2>/dev/null)
    local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    if [[ -n $context ]]; then
      echo -e "\n\033[34m☸️  $context${namespace:+:$namespace}\033[0m"
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec preexec_kubectl
