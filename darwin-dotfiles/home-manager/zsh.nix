{ config, pkgs, lib, ... }: {
  enable = true;

  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };

  sessionVariables = {
    EDITOR = "vim";
    ZSH_DISABLE_COMPFIX = "true";
    GPG_TTY = "$TTY";
    BUN_INSTALL = "$HOME/.bun";
    PATH = "$HOME/go/bin:$HOME/.bun/bin:$PATH";
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  };

  shellAliases = {
    grep = "grep --color=auto";
    egrep = "egrep --color=auto";
    fgrep = "fgrep --color=auto";

    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";

    v = "nvim";
    vi = "nvim";
    vim = "nvim";

    c = "clear";
    nf = "clear; neofetch";

    # k8s
    k = "kubectl";
    kg = "kubectl get";
    ks = "kubectl -n kube-system";
    ksg = "kubectl -n kube-system";
    kconfig = ''
      kubectl config view -o json | jq -r '
        .clusters[].name as $cluster |
        .users[].name as $user |
        .contexts[] |
        select(.context.cluster == $cluster and .context.user == $user) |
        "context: " + .name + ",\ncluster: " + .context.cluster + ",\nuser: " + .context.user + "\n"
      '
    '';

    # terraform
    t = "terraform";
    ti = "terraform fmt; terraform init";
    tp = "terraform fmt; terraform plan";
    ta = "terraform fmt; terraform apply";
    taa = "terraform fmt; terraform apply -auto-approve";
    td = "terraform destroy";
    tda = "terraform destroy -auto-approve";
    tw = "terraform workspace";

    # git
    gpl = "git log --graph --abbrev-commit --decorate --all --date=format:\"%Y-%m-%d %I:%M %p\" --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%ad%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
    gps = "git status --short --branch";
    gpb = "git for-each-ref --sort=-committerdate --format \"%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(committerdate:relative)%(color:reset) - %(color:blue)%(contents:subject)%(color:reset)\" refs/heads/";
    gpba = "git for-each-ref --sort=-committerdate --format \"%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(committerdate:relative)%(color:reset) - %(color:blue)%(contents:subject)%(color:reset)\" refs/heads/ refs/remotes/";
    ginit = "git init && git commit -m \"root\" --allow-empty";
  };

  initExtra = ''
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

    # Keybindings
    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward
    bindkey '^[w' kill-region

    zle_highlight+=(paste:none)

    # History options
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