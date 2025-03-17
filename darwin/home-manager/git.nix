{ ... }: {
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Dmitriy Dovguchev";
    userEmail = "your@email.com";
    signing = {
      key = null;
      signByDefault = true;
    };
    ignores = [
      ".idea" ".vs" ".vsc" ".vscode" "node_modules" "npm-debug.log"
      "__pycache__" "*.pyc" ".ipynb_checkpoints" "__sapper__"
      ".DS_Store" "kls_database.db" ".terraform" ".terragrunt-cache"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      pull = { ff = false; commit = false; rebase = true; };
      fetch.prune = true;
      push.autoSetupRemote = true;
      delta.line-numbers = true;
    };
  };
}