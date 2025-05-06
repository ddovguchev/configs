{ config, pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.dmitriy = {
    name = "dmitriy";
    home = "/Users/dmitriy";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  environment.variables = {
    PATH = "/opt/homebrew/bin:$PATH";
  };

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;

  imports = [ ./packages.nix ./yabai.nix ./skhd.nix ];

  home-manager.users.dmitriy = { config, pkgs, ... }: {
    home.username = "dmitriy";
    home.homeDirectory = "/Users/dmitriy";
    home.stateVersion = "23.11";

    home.packages = with pkgs; [
      tenv gnupg
    ];

    home.sessionVariables = {
      NVM_DIR = "${config.home.homeDirectory}/.nvm";
      GNUPGHOME = "${config.home.homeDirectory}/.gnupg";
      PATH = "${config.home.homeDirectory}/.tenv/bin:$PATH";
    };

    programs.zsh.enable = true;

    home.file.".zshrc".force = true;
    home.file.".zshrc".text = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
      export PATH="$HOME/.tenv/bin:$PATH"
      export GNUPGHOME="$HOME/.gnupg"
    '';
  };
}