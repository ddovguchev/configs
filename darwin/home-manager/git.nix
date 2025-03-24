{ lib, ... }: {
  programs.git = {
    enable = true;

    userName  = "dovguchev dmitriy";
    userEmail = "dzmitry.douhushau@softnetix.io";

    delta.enable = true;

    # Отключаем GPG-подписи
    signing = {
      key = null;
      signByDefault = false;
    };

    # Глобальные игнорируемые файлы
    ignores = [
      # IDE
      ".idea" ".vscode" ".vs" ".vsc"

      # Node.js / JavaScript / TypeScript
      "node_modules" "npm-debug.log" "yarn.lock" "pnpm-lock.yaml" "package-lock.json" "dist" "build"

      # Python
      "__pycache__" "*.pyc" "*.pyo" "*.pyd" ".python-version" ".ipynb_checkpoints" ".pytest_cache" ".venv" "env" "venv"

      # Go
      "go.sum" "go.mod" "bin/" "pkg/"

      # Terraform / Terragrunt
      ".terraform" ".terragrunt-cache" "terraform.tfstate" "terraform.tfstate.backup" "*.tfplan"

      # macOS системные файлы
      ".DS_Store"

      # Прочее
      "kls_database.db"
    ];

    extraConfig = {
      init.defaultBranch = "main";
      pull = {
        ff = "false";
        commit = "false";
        rebase = true;
      };
      fetch.prune = true;
      push.autoSetupRemote = true;
      delta.line-numbers = true;

      # Убираем GPG из глобальной конфигурации
      commit.gpgsign = false;
      tag.gpgsign = false;
      gpg.format = lib.mkForce null;
      gpg.openpgp.program = lib.mkForce null;
    };
  };
}