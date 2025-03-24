{ config, pkgs, lib, ... }: {
  enable = true;

  history.size = 10000;
  history.path = "${config.xdg.dataHome}/zsh/history";

  shellAliases = {
    # Обновление zsh-плагинов
    zsh-update-plugins = "find \"$ZDOTDIR/plugins\" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q";

    # Neovim конфигурация и редактор
    nvimrc = "nvim ~/.config/nvim/";
    vim = "nvim";
    vi = "nvim";
    v = "nvim";

    # SSH через Kitty
    sshk = "kitty +kitten ssh";

    # Цветной grep
    grep = "grep --color=auto";
    egrep = "egrep --color=auto";
    fgrep = "fgrep --color=auto";

    # Подтверждение перед перезаписью файлов
    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";

    # Утилиты
    c = "clear";
    nf = "clear; neofetch";

    # Kubernetes
    k = "kubectl";
    kg = "kubectl get";
    kconfig = "kubectl config view -o json | jq -r '.clusters[].name as \\$cluster | .users[].name as \\$user | .contexts[] | select(.context.cluster == \\$cluster and .context.user == \\$user) | \"context: \" + .name + \",\\ncluster: \" + .context.cluster + \",\\nuser: \" + .context.user + \"\\n\"'";

    # Terraform
    t = "terraform";
    ti = "terraform fmt; terraform init";
    tp = "terraform fmt; terraform plan";
    ta = "terraform fmt; terraform apply";
    taa = "terraform fmt; terraform apply -auto-approve";
    td = "terraform destroy";
    tda = "terraform destroy -auto-approve";
    tw = "terraform workspace";

    # Git
    gpl = "git log --graph --abbrev-commit --decorate --all --date=format:\"%Y-%m-%d %I:%M %p\" --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%ad%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
    gps = "git status --short --branch";
    gpb = "git for-each-ref --sort=-committerdate --format '%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(committerdate:relative)%(color:reset) - %(color:blue)%(contents:subject)%(color:reset)' refs/heads/";
    gpba = "git for-each-ref --sort=-committerdate --format '%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(committerdate:relative)%(color:reset) - %(color:blue)%(contents:subject)%(color:reset)' refs/heads/ refs/remotes/";
    ginit = "git init && git commit -m \"root\" --allow-empty";
    gstash = "git stash --keep-index";
    gstaash = "git stash --include-untracked";
    gstaaash = "git stash --all";
    gcomment = "git commit --amend --no-edit";

    # ls с цветом на macOS
    ls = if pkgs.stdenv.isDarwin then "ls -G" else "ls --color=auto";
  };

  initExtra = ''
    ZSH_DISABLE_COMPFIX=true
    export EDITOR=nvim

    # Инициализация NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/etc/bash_completion.d/nvm"

    # Инициализация PYENV
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv 1>/dev/null 2>&1; then
      eval "$(pyenv init -)"
    fi

    # Инициализация GOENV
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    if command -v goenv 1>/dev/null 2>&1; then
      eval "$(goenv init -)"
    fi

    # Инициализация SDKMAN!
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

    # Инициализация TENV
    export PATH="$HOME/.tenv/bin:$PATH"

    # FZF-tab preview + стили
    bindkey -e
    zstyle ':completion:*:git-checkout:*' sort false
    zstyle ':completion:*:descriptions' format '[%d]'
    zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:*' switch-group '<' '>'

    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:ls:*' fzf-preview 'cat $realpath'

    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward
    bindkey '^[w' kill-region

    zle_highlight+=(paste:none)

    # История shell
    setopt appendhistory
    setopt sharehistory
    setopt hist_ignore_space
    setopt hist_ignore_all_dups
    setopt hist_save_no_dups
    setopt hist_ignore_dups
    setopt hist_find_no_dups
  '';

  oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "sudo"
      "docker"
      "golang"
      "kubectl"
      "kubectx"
      "rust"
      "command-not-found"
      "pass"
      "helm"
    ];
  };

  plugins = [
    {
      name = "zsh-autosuggestions";
      src = pkgs.zsh-autosuggestions;
      file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    }
    {
      name = "zsh-completions";
      src = pkgs.zsh-completions;
      file = "share/zsh-completions/zsh-completions.zsh";
    }
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.zsh-syntax-highlighting;
      file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }
    {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab;
      file = "share/fzf-tab/fzf-tab.plugin.zsh";
    }
  ];
}