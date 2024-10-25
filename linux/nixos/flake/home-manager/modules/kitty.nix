{ pkgs, lib, ... }:

let
  kittyConfig = ''
    font_family      JetBrains Mono
    font_size 12.0

    scrollback_lines 2000

    cursor #cccccc
    cursor_shape block

    background #1a1b26
    foreground #c0caf5
    background_opacity 0.75

    selection_foreground #ffffff
    selection_background #14b8a6

    color0 #0b0c15
    color1 #d2556c
    color2 #7cd47b
    color3 #efb184
    color4 #6ca1f3
    color5 #b78df0
    color6 #69bcf4
    color7 #c0caf5
    color8  #39404a
    color9  #f7768e
    color10 #85e89d
    color11 #f4cf8d
    color12 #8fb9ff
    color13 #d9a3ff
    color14 #8fd3ff
    color15 #f0f3f6

    # Mappings
    map kitty_mod+c copy_to_clipboard
    map kitty_mod+v paste_from_clipboard
    map kitty_mod+t new_tab
    map kitty_mod+w close_window
    map kitty_mod+right next_tab
    map kitty_mod+left previous_tab
    map kitty_mod+f5 load_config_file
    map cmd+q quit
  '';
in
{
  home.packages = [
    pkgs.kitty
  ];

  programs.kitty = {
    enable = true;
    extraConfig = kittyConfig;
  };
}