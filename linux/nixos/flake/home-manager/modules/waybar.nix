{ pkgs, lib, ... }:

{
  home.packages = [
    pkgs.waybar
  ];

  programs.waybar = {
    enable = true;

    extraConfig = ''
      {
        "layer": "top",
        "position": "top",
        "width": 100,
        "height": 30,
        "background": "#1a1b26",
        "foreground": "#c0caf5",
        "modules-left": ["sway/workspace", "sway/window"],
        "modules-center": ["clock"],
        "modules-right": ["network", "battery", "pulseaudio", "tray"],

        "clock": {
          "format": "%Y-%m-%d %H:%M:%S"
        },

        "battery": {
          "format": "{capacity}%"
        }
      }
    '';

    # Стили для Waybar
    style = ''
      #panel {
          background-color: #1a1b26;
          color: #c0caf5;
      }

      #clock {
          padding: 0 10px;
      }

      #battery {
          padding: 0 10px;
      }

      #network {
          padding: 0 10px;
      }
    '';
  };
}