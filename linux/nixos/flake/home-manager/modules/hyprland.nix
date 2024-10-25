{ pkgs, ... }:

{
  home.packages = [
    pkgs.hyprland
  ];

  programs.hyprland = {
    enable = true;

    config = ''
      ################
      ### MONITORS ###
      ################

      monitor=eDP-1,preferred,auto,auto

      ###################
      ### MY PROGRAMS ###
      ###################

      $terminal = kitty
      $fileManager = dolphin
      $menu = wofi --show drun

      #################
      ### AUTOSTART ###
      #################

      exec-once = waybar &
      exec-once = hyprpaper &

      ###################
      ### INPUT ###
      ###################

      input {
        kb_layout = us
      }

      ###################
      ### KEYBINDINGS ###
      ###################

      $mainMod = SUPER
      bind = $mainMod, Q, exec, $terminal
    '';
  };
}