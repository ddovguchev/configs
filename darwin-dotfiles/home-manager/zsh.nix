{
  config,
  pkgs,
  lib,
  ...
}: {
  enable = true;
  history.size = 10000;
  history.path = "${config.xdg.dataHome}/zsh/history";
  shellAliases = {
    # Colorize grep output (good for log files)
    grep = "grep --color=auto";
    egrep = "egrep --color=auto";
    fgrep = "fgrep --color=auto";

    # confirm before overwriting something
    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";

    # my own
    v = "nvim";
    vi = "nvim";
    vim = "nvim";

    c = "clear";
    nf = "clear; neofetch";

    # k8s
    k = "kubectl";
    kg = "kubectl get";
    kconfig = "kubectl config view -o json | jq -r \".clusters[].name as \$cluster | .users[].name as \$user | .contexts[] | select(.context.cluster == \$cluster and .context.user == \$user) | \\\"context: \\\" + .name + \",\\\\ncluster: \\\" + .context.cluster + \",\\\\nuser: \\\" + .context.user + \\\"\\\\n\"\"";

    # terraform
    t = "terraform";
    ti = "terraform fmt; terraform init";
    tp = "terraform fmt; terraform plan";
    ta = "terraform fmt; terraform apply";
    taa = "terraform fmt; terraform apply -auto-approve";
    td = "terraform destroy";
    tda = "terraform destroy -auto-approve";
    tw = "terraform workspace";

    # github alias
    gpl = "git log --graph --abbrev-commit --decorate --all --date=format:\"%Y-%m-%d %I:%M %p\" --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%ad%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";

    gps = "git status --short --branch";
    gpb = "git for-each-ref --sort=-committerdate --format \"%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(committerdate:relative)%(color:reset) - %(color:blue)%(contents:subject)%(color:reset)\" refs/heads/";
    gpba = "git for-each-ref --sort=-committerdate --format \"%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(committerdate:relative)%(color:reset) - %(color:blue)%(contents:subject)%(color:reset)\" refs/heads/ refs/remotes/";

    ginit = "git init && git commit -m \"root\" --allow-empty";

    gstash = "git stash --keep-index";
    gstaash = "git stash --include-untracked";
    gstaaash = "git stash --all";

    gcomment = "git commit --amend --no-edit";
  };
  initExtra = ''
    ZSH_DISABLE_COMPFIX=true
    export EDITOR=nvim
    if [ -n "$TTY" ]; then
      export GPG_TTY=$(tty)
    else
      export GPG_TTY="$TTY"
    fi

    export BUN_INSTALL=$HOME/.bun
    export PATH="$HOME/go/bin:$BUN_INSTALL/bin:$PATH"

    # SSH_AUTH_SOCK set to GPG to enable using gpgagent as the ssh agent.
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent

    bindkey -e

    # disable sort when completing `git checkout`
    zstyle ':completion:*:git-checkout:*' sort false

    # set descriptions format to enable group support
    # NOTE: don't use escape sequences here, fzf-tab will ignore them
    zstyle ':completion:*:descriptions' format '[%d]'

    # set list-colors to enable filename colorizing
    zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

    # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
    zstyle ':completion:*' menu no

    # preview directory's content with eza when completing cd
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:ls:*' fzf-preview 'cat $realpath'

    # switch group using `<` and `>`
    zstyle ':fzf-tab:*' switch-group '<' '>'

    # Keybindings
    bindkey -e
    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward
    bindkey '^[w' kill-region

    zle_highlight+=(paste:none)

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