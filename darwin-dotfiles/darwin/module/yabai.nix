{ config, pkgs, ... }: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = pkgs.yabai;

    config = {
      # Window management
      external_bar = "all:0:0";
      layout = "stack";
      auto_balance = "off";

      # Mouse controls
      mouse_modifier = "alt";
      mouse_action2 = "resize";
      mouse_action1 = "move";

      # Padding and gaps
      top_padding = 5;
      bottom_padding = 5;
      left_padding = 5;
      right_padding = 5;
      window_gap = 5;

      # Visual effects
      window_opacity = "on";
      active_window_opacity = 1.0;
      normal_window_opacity = 0.90;

      # Focus behavior
      focus_follows_mouse = "autofocus";

      # Performance
      window_shadow = "float";
      window_animation_duration = 0.0;
    };

    extraConfig = ''
      # =============================================================================
      # YABAI CONFIGURATION
      # =============================================================================

      # Load scripting addition
      yabai --load-sa

      # =============================================================================
      # SIGNALS FOR SKETCHYBAR
      # =============================================================================
      yabai -m signal --add event=window_focused   action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created   action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"

      # =============================================================================
      # SYSTEM APPS - EXCLUDE FROM TILING
      # =============================================================================
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add app="^Finder$" manage=off
      yabai -m rule --add app="^Activity Monitor$" manage=off
      yabai -m rule --add app="^Console$" manage=off
      yabai -m rule --add app="^Disk Utility$" manage=off
      yabai -m rule --add app="^Terminal$" manage=off
      yabai -m rule --add app="^iTerm2$" manage=off
      yabai -m rule --add app="^Kitty$" manage=off

      # =============================================================================
      # DIALOG WINDOWS - EXCLUDE FROM TILING
      # =============================================================================
      yabai -m rule --add title="Preferences$" manage=off
      yabai -m rule --add title="Settings$" manage=off
      yabai -m rule --add title=".*[Dd]ialog.*" manage=off
      yabai -m rule --add title=".*[Mm]odal.*" manage=off
      yabai -m rule --add title=".*[Pp]opup.*" manage=off

      # =============================================================================
      # SPACE LABELS
      # =============================================================================
      yabai -m space 1 --label todo
      yabai -m space 2 --label productive
      yabai -m space 3 --label chat
      yabai -m space 4 --label utils
      yabai -m space 5 --label code

      # =============================================================================
      # APPLICATION RULES BY SPACE
      # =============================================================================

      # TODO SPACE - Productivity apps
      yabai -m rule --add app="Reminder" space=todo
      yabai -m rule --add app="Mail" space=todo
      yabai -m rule --add app="Calendar" space=todo
      yabai -m rule --add app="Notes" space=todo
      yabai -m rule --add app="Stickies" space=todo

      # PRODUCTIVE SPACE - Development and work
      yabai -m rule --add app="Alacritty" space=productive
      yabai -m rule --add app="Arc" space=productive
      yabai -m rule --add app="Safari" space=productive
      yabai -m rule --add app="Firefox" space=productive
      yabai -m rule --add app="LibreWolf" space=productive
      yabai -m rule --add app="Cursor" space=productive
      yabai -m rule --add app="Notion" space=productive
      yabai -m rule --add app="Obsidian" space=productive

      # CHAT SPACE - Communication
      yabai -m rule --add app="Microsoft Teams" space=chat
      yabai -m rule --add app="Slack" space=chat
      yabai -m rule --add app="Signal" space=chat
      yabai -m rule --add app="Messages" space=chat
      yabai -m rule --add app="Telegram" space=chat
      yabai -m rule --add app="Discord" space=chat
      yabai -m rule --add app="WhatsApp" space=chat
      yabai -m rule --add app="ChatGPT" space=chat

      # UTILS SPACE - Utilities and media
      yabai -m rule --add app="Spotify" space=utils
      yabai -m rule --add app="Bitwarden" space=utils
      yabai -m rule --add app="Ivanti Secure Access" space=utils
      yabai -m rule --add app="Hammerspoon" space=utils
      yabai -m rule --add app="System Settings" space=utils
      yabai -m rule --add app="System Information" space=utils
      yabai -m rule --add app="Activity Monitor" space=utils
      yabai -m rule --add app="Console" space=utils

      # CODE SPACE - Development tools
      yabai -m rule --add app="Visual Studio Code" space=code
      yabai -m rule --add app="IntelliJ IDEA" space=code
      yabai -m rule --add app="Xcode" space=code
      yabai -m rule --add app="Android Studio" space=code
      yabai -m rule --add app="Sublime Text" space=code
      yabai -m rule --add app="Vim" space=code
      yabai -m rule --add app="Neovim" space=code
      yabai -m rule --add app="Emacs" space=code

      # =============================================================================
      # LAYOUT RULES
      # =============================================================================

      # Use bsp layout for coding
      yabai -m rule --add app="Visual Studio Code" layout=bsp
      yabai -m rule --add app="IntelliJ IDEA" layout=bsp
      yabai -m rule --add app="Xcode" layout=bsp
      yabai -m rule --add app="Android Studio" layout=bsp

      # Use stack layout for terminals
      yabai -m rule --add app="Alacritty" layout=stack
      yabai -m rule --add app="Terminal" layout=stack
      yabai -m rule --add app="iTerm2" layout=stack
      yabai -m rule --add app="Kitty" layout=stack

      # =============================================================================
      # FLOAT RULES
      # =============================================================================

      # Float calculator and small utilities
      yabai -m rule --add app="Calculator" manage=off
      yabai -m rule --add app="Dictionary" manage=off
      yabai -m rule --add app="Preview" manage=off
      yabai -m rule --add app="QuickTime Player" manage=off

      # =============================================================================
      # PERFORMANCE OPTIMIZATIONS
      # =============================================================================

      # Disable animations for better performance
      yabai -m config window_animation_duration 0.0
      yabai -m config window_shadow float

      echo "Yabai configuration loaded successfully"
    '';
  };
}

